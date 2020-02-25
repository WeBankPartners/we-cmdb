<template>
  <Row>
    <Col span="18">
      <div style="padding-right: 20px">
        <Card style="height: calc(100vh - 108px);">
          <Row slot="title">
            <Col span="10">
              <p>
                {{ $t('architecture_diagram') }}
                <span class="header-buttons-container margin-left">
                  <Tooltip :content="$t('add_layer')" placement="top-start">
                    <Button size="small" @click="isAddNewLayerModalVisible = true" icon="md-add"></Button>
                  </Tooltip>
                </span>
              </p>
            </Col>
            <Col span="13" offset="1">
              <span class="filter-title">{{ $t('state') }}</span>
              <Select
                multiple
                :max-tag-count="3"
                v-model="selectedStatus"
                @on-change="handleStatusChange"
                style="width: 350px;"
              >
                <Option v-for="item in statusList" :value="item" :key="item">
                  {{ item }}
                </Option>
              </Select>
            </Col>
          </Row>
          <div class="graph-container" id="graph"></div>
          <Modal v-model="isAddNewLayerModalVisible" :title="$t('add_layer')" @on-visible-change="addLayerModalToggle">
            <Form class="validation-form" ref="newLayerForm" :model="newLayer" label-position="left" :label-width="100">
              <FormItem label="Key" prop="addNewLayerCode">
                <Input v-model="newLayer.addNewLayerCode" />
              </FormItem>
              <FormItem label="Value" prop="addNewLayerValue">
                <Input v-model="newLayer.addNewLayerValue" />
              </FormItem>
              <FormItem :label="$t('description')" prop="addNewLayerDescription">
                <Input v-model="newLayer.addNewLayerDescription" />
              </FormItem>
            </Form>
            <div slot="footer">
              <Button type="primary" @click="addNewLayer('newLayerForm')" :loading="buttonLoading.newLayer">{{
                $t('submit')
              }}</Button>
            </div>
          </Modal>
        </Card>
      </div>
    </Col>
    <Col
      span="6"
      offset="0"
      class="func-wrapper"
      v-if="JSON.stringify(currentSelectedLayer) !== '{}' || JSON.stringify(currentSelectedCI) !== '{}'"
    >
      <Card v-if="isLayerSelected">
        <Row slot="title">
          <p style="width: calc(100% - 165px);">
            {{ currentSelectedLayer.name }}
          </p>
          <span class="header-buttons-container">
            <Tooltip :content="$t('new_ci_type')" placement="top-start">
              <Button size="small" @click="isAddNewCITypeModalVisible = true" icon="md-add"></Button>
            </Tooltip>
            <Tooltip :content="$t('edit_layer_name')" placement="top-start">
              <Button size="small" @click="isEditLayerNameModalVisible = true" icon="md-build"></Button>
            </Tooltip>
            <Tooltip :content="$t('move_up_layer')" placement="top-start">
              <Button
                size="small"
                @click="upLayer(currentSelectedLayer.layerId)"
                :loading="buttonLoading.upLayer"
                icon="md-arrow-round-up"
              ></Button>
            </Tooltip>
            <Tooltip :content="$t('move_down_layer')" placement="top-start">
              <Button
                size="small"
                @click="downLayer(currentSelectedLayer.layerId)"
                :loading="buttonLoading.downLayer"
                icon="md-arrow-round-down"
              ></Button>
            </Tooltip>
            <Tooltip :content="$t('delete_layer')" placement="top-start">
              <Button size="small" @click="deleteLayer(currentSelectedLayer.layerId)" icon="ios-trash"></Button>
            </Tooltip>
          </span>
        </Row>
        <div class="attrContainer">
          <Collapse accordion>
            <Panel
              class="collapse-row"
              v-for="(item, index) in currentSelectLayerChildren.ciTypes"
              :key="item.ciTypeId"
              :name="index.toString()"
            >
              <div class="collapse-row-title">
                <span
                  :class="`${item.status === 'decommissioned' ? 'decommissionedLabel ' : ''}ci-type-header-title`"
                  >{{ item.name }}</span
                >
                <span class="header-buttons-container margin-right">
                  <Tooltip v-if="item.status === 'decommissioned'" :content="$t('roll_back')" placement="top-start">
                    <Button
                      size="small"
                      @click.stop.prevent="revertCI(item.ciTypeId)"
                      :loading="buttonLoading.revertCI"
                      icon="md-redo"
                    ></Button>
                  </Tooltip>
                  <Tooltip v-else :content="$t('delete_ci')" placement="top-start">
                    <Button
                      size="small"
                      @click.stop.prevent="deleteCI(item.ciTypeId, item.status)"
                      icon="ios-trash"
                    ></Button>
                  </Tooltip>
                </span>
              </div>
              <div slot="content">
                <Form class="validation-form" :model="item.form" label-position="left" :label-width="100">
                  <FormItem :label="$t('ci_type_id')" prop="tableName">
                    <Input v-model="item.form.tableName" disabled></Input>
                  </FormItem>
                  <FormItem :label="$t('refrence_layer')">
                    <Select v-model="item.form.layerId" :disabled="item.form.status === 'decommissioned'">
                      <Option v-for="layer in layers" :value="layer.layerId" :key="layer.layerId">{{
                        layer.name
                      }}</Option>
                    </Select>
                  </FormItem>
                  <FormItem :label="$t('description')" prop="description">
                    <Input v-model="item.form.description" :disabled="item.form.status === 'decommissioned'"></Input>
                  </FormItem>
                  <FormItem :label="$t('icon')">
                    <Select v-model="item.form.imageFileId">
                      <img
                        v-if="item.form.imageFileId"
                        :src="`${baseURL}/files/${item.form.imageFileId}.png`"
                        slot="prefix"
                        height="24"
                        width="24"
                        style="margin-top:2px;"
                      />
                      <Option v-for="(item, i) in imgs" :key="i + 1" :value="i + 1">
                        <img slot :src="`${baseURL}/files/${i + 1}.png`" width="30" height="30" />
                        &nbsp;
                      </Option>
                    </Select>
                  </FormItem>
                  <FormItem>
                    <Button
                      type="primary"
                      small
                      @click="saveCiType(item.ciTypeId, item.form)"
                      :loading="buttonLoading.saveCiType"
                      :disabled="item.form.status !== 'notCreated'"
                      >{{ $t('save_draft') }}</Button
                    >
                    <Button
                      type="primary"
                      small
                      @click="submitCiType(item.ciTypeId, item.form)"
                      :loading="buttonLoading.submitCiType"
                      style="margin-left: 8px"
                      :disabled="item.form.status === 'decommissioned'"
                      >{{ $t('submit') }}</Button
                    >
                  </FormItem>
                </Form>
              </div>
            </Panel>
          </Collapse>
        </div>
        <Modal
          v-model="isAddNewCITypeModalVisible"
          :title="$t('new_ci_type')"
          @on-visible-change="addCiTypeModalToggle"
          footer-hide
        >
          <Form
            class="validation-form"
            ref="addNewCITypeForm"
            :model="addNewCITypeForm"
            label-position="left"
            :label-width="100"
          >
            <FormItem :label="$t('table_name')" prop="name">
              <Input v-model="addNewCITypeForm.name"></Input>
            </FormItem>
            <FormItem :label="$t('ci_type_id')" prop="tableName">
              <Input v-model="addNewCITypeForm.tableName"></Input>
            </FormItem>
            <FormItem :label="$t('refrence_layer')">
              <Select disabled v-model="addNewCITypeForm.layerId">
                <Option v-for="layer in layers" :value="layer.layerId" :key="layer.layerId">{{ layer.name }}</Option>
              </Select>
            </FormItem>
            <FormItem :label="$t('description')" prop="description">
              <Input v-model="addNewCITypeForm.description"></Input>
            </FormItem>
            <FormItem :label="$t('icon')">
              <Select v-model="addNewCITypeForm.imageFileId">
                <img
                  v-if="addNewCITypeForm.imageFileId"
                  :src="`${baseURL}/files/${addNewCITypeForm.imageFileId}.png`"
                  slot="prefix"
                  height="24"
                  width="24"
                />
                <Option v-for="(item, i) in imgs" :key="i + 1" :value="i + 1">
                  <img slot :src="`${baseURL}/files/${i + 1}.png`" width="30" height="30" />
                  &nbsp;
                </Option>
              </Select>
            </FormItem>
            <FormItem>
              <Button
                type="primary"
                small
                @click="addNewCIType"
                :loading="buttonLoading.addNewCIType"
                style="float: right"
                >{{ $t('confirm') }}</Button
              >
            </FormItem>
          </Form>
        </Modal>
      </Card>
      <Card v-else>
        <Row slot="title">
          <Col span="18">
            <p>{{ currentSelectedCI.name }}</p>
          </Col>
          <span class="header-buttons-container">
            <Tooltip :content="$t('new_ci_attribute')" placement="top-start">
              <Button
                size="small"
                @click="addNewAttrHandler"
                :loading="buttonLoading.addNewAttrHandler"
                icon="md-add"
              ></Button>
            </Tooltip>
            <Tooltip :content="$t('edit_name')" placement="top-start">
              <Button size="small" @click="isEditCINameModalVisible = true" icon="md-build"></Button>
            </Tooltip>
          </span>
        </Row>
        <div class="attrContainer">
          <Collapse accordion @on-change="onCIAttrCollapeOpen">
            <Panel
              class="collapse-row"
              v-for="item in currentSelectedCIChildren"
              :key="item.ciTypeAttrId"
              :name="item.ciTypeAttrId.toString()"
              v-if="!item.isHidden"
            >
              <div class="collapse-row-title">
                <span :class="`${item.status === 'decommissioned' ? 'decommissionedLabel ' : ''}attr-header-title`">{{
                  item.name
                }}</span>
                <span class="header-buttons-container margin-right">
                  <Tooltip :content="$t('move_up_ci_attribute')" placement="top-start">
                    <Button
                      size="small"
                      @click.stop.prevent="moveUpAttr(item.ciTypeAttrId)"
                      icon="md-arrow-round-up"
                      :loading="buttonLoading.moveUpAttr"
                    ></Button>
                  </Tooltip>
                  <Tooltip :content="$t('move_down_ci_attribute')" placement="top-start">
                    <Button
                      size="small"
                      @click.stop.prevent="moveDownAttr(item.ciTypeAttrId)"
                      icon="md-arrow-round-down"
                      :loading="buttonLoading.moveDownAttr"
                    ></Button>
                  </Tooltip>
                  <Tooltip v-if="item.status === 'decommissioned'" :content="$t('roll_back')" placement="top-start">
                    <Button
                      size="small"
                      @click.stop.prevent="revertCIAttr(item.ciTypeAttrId)"
                      icon="md-redo"
                      :loading="buttonLoading.revertCIAttr"
                    ></Button>
                  </Tooltip>
                  <Tooltip v-else :content="$t('delete')" placement="top-start">
                    <Button
                      size="small"
                      @click.stop.prevent="deleteCIAttr(item.ciTypeAttrId, item.status)"
                      icon="ios-trash"
                    ></Button>
                  </Tooltip>
                </span>
              </div>
              <div slot="content">
                <Form class="validation-form" ref="ciAttrForm" label-position="right" :label-width="140">
                  <FormItem prop="propertyName" :label="$t('ci_attribute_id')">
                    <Input v-model="item.form.propertyName" disabled></Input>
                  </FormItem>
                  <FormItem prop="name" :label="$t('ci_attribute_name')">
                    <Input v-model="item.form.name" :disabled="item.form.status === 'decommissioned'"></Input>
                  </FormItem>
                  <FormItem :label="$t('search_filter_number')" prop="searchSeqNo">
                    <InputNumber
                      :min="0"
                      :disabled="item.form.status === 'decommissioned'"
                      v-model="item.form.searchSeqNo"
                    ></InputNumber>
                  </FormItem>
                  <FormItem prop="inputType" :label="$t('data_type')">
                    <Select
                      v-model="item.form.inputType"
                      @on-change="onInputTypeChange($event, item.form.status !== 'notCreated')"
                      :disabled="item.form.status !== 'notCreated'"
                    >
                      <Option v-for="item in allInputTypes" :value="item" :key="item">{{ item }}</Option>
                    </Select>
                  </FormItem>
                  <FormItem
                    v-if="item.form.inputType === 'text' || item.form.inputType === 'textArea'"
                    prop="regularExpressionRule"
                    :label="$t('regular_rule')"
                  >
                    <Input v-model="item.form.regularExpressionRule"></Input>
                  </FormItem>
                  <FormItem :label="$t('real_type')">
                    <Input v-model="item.form.propertyType" disabled></Input>
                  </FormItem>
                  <FormItem
                    prop="length"
                    :label="$t('length')"
                    v-if="
                      item.form.inputType === 'text' ||
                        item.form.inputType === 'textArea' ||
                        item.form.inputType === 'number'
                    "
                  >
                    <InputNumber
                      :min="1"
                      :disabled="item.form.status !== 'notCreated'"
                      v-model="item.form.length"
                    ></InputNumber>
                  </FormItem>
                  <FormItem
                    prop="referenceId"
                    v-if="item.form.inputType === 'ref' || item.form.inputType === 'multiRef'"
                    :label="$t('reference_select')"
                  >
                    <Select v-model="item.form.referenceId" :disabled="item.form.status === 'decommissioned'">
                      <Option v-for="item in allCiTypes" :value="item.ciTypeId" :key="item.ciTypeId">{{
                        item.name
                      }}</Option>
                    </Select>
                  </FormItem>
                  <FormItem
                    prop="referenceName"
                    v-if="item.form.inputType === 'ref' || item.form.inputType === 'multiRef'"
                    :label="$t('reference_name')"
                  >
                    <Input v-model="item.form.referenceName" :disabled="item.form.status === 'decommissioned'"></Input>
                  </FormItem>
                  <FormItem
                    prop="referenceType"
                    v-if="item.form.inputType === 'ref' || item.form.inputType === 'multiRef'"
                    :label="$t('reference_type')"
                  >
                    <Select v-model="item.form.referenceType" :disabled="item.form.status === 'decommissioned'">
                      <Option v-for="item in allReferenceTypes" :value="item.codeId" :key="item.codeId">{{
                        item.value
                      }}</Option>
                    </Select>
                  </FormItem>
                  <FormItem
                    prop="referenceId"
                    v-if="item.form.inputType === 'select' || item.form.inputType === 'multiSelect'"
                    :label="$t('select')"
                  >
                    <Select
                      v-if="item.form.isSystem === true"
                      clearable
                      v-model="item.form.referenceId"
                      :disabled="item.form.status === 'decommissioned'"
                    >
                      <Option
                        v-for="enumItem in currentSelectedCIAttrEnum"
                        :value="enumItem.catId"
                        :key="enumItem.catId"
                        style="max-width: 300px"
                        >{{ `[${'system'}] ${enumItem.catName}` }}</Option
                      >
                    </Select>

                    <Select
                      v-else
                      clearable
                      v-model="item.form.referenceId"
                      :disabled="item.form.status === 'decommissioned'"
                    >
                      <span slot="prefix" @click.stop.prevent="openEnumGroupModal(null)">@+</span>
                      <Option
                        v-for="enumItem in currentSelectedCIAttrEnum"
                        :value="enumItem.catId"
                        :key="enumItem.catId"
                        style="max-width: 300px"
                      >
                        {{ `[${enumItem.catTypeId === 2 ? 'common' : 'private'}] ${enumItem.catName}` }}
                        <span style="float:right">
                          <Button
                            @click.stop.prevent="openEnumGroupModal(enumItem)"
                            icon="ios-build"
                            type="primary"
                            size="small"
                          ></Button>
                        </span>
                      </Option>
                    </Select>
                  </FormItem>
                  <FormItem prop="isRefreshable" :label="$t('is_refreshable')">
                    <RadioGroup v-model="item.form.isRefreshable">
                      <Radio :disabled="item.form.status === 'decommissioned'" label="yes">Yes</Radio>
                      <Radio :disabled="item.form.status === 'decommissioned'" label="no">No</Radio>
                    </RadioGroup>
                  </FormItem>
                  <FormItem prop="isDisplayed" :label="$t('is_displayed')">
                    <RadioGroup v-model="item.form.isDisplayed">
                      <Radio :disabled="item.form.status === 'decommissioned'" label="yes">Yes</Radio>
                      <Radio :disabled="item.form.status === 'decommissioned'" label="no">No</Radio>
                    </RadioGroup>
                  </FormItem>
                  <FormItem
                    prop="isAccessControlled"
                    v-if="
                      item.form.inputType === 'select' ||
                        item.form.inputType === 'ref' ||
                        item.form.inputType === 'multiSelect' ||
                        item.form.inputType === 'multiRef'
                    "
                    :label="$t('is_access_controlled')"
                  >
                    <RadioGroup v-model="item.form.isAccessControlled">
                      <Radio :disabled="item.form.status === 'decommissioned'" label="yes">Yes</Radio>
                      <Radio :disabled="item.form.status === 'decommissioned'" label="no">No</Radio>
                    </RadioGroup>
                  </FormItem>
                  <FormItem prop="isNullable" :label="$t('is_nullable')">
                    <RadioGroup v-model="item.form.isNullable">
                      <Radio :disabled="item.form.status === 'decommissioned'" label="yes">Yes</Radio>
                      <Radio :disabled="item.form.status === 'decommissioned'" label="no">No</Radio>
                    </RadioGroup>
                  </FormItem>
                  <FormItem prop="isEditable" :label="$t('is_editable')">
                    <RadioGroup v-model="item.form.isEditable">
                      <Radio :disabled="item.form.status === 'decommissioned'" label="yes">Yes</Radio>
                      <Radio :disabled="item.form.status === 'decommissioned'" label="no">No</Radio>
                    </RadioGroup>
                  </FormItem>
                  <FormItem prop="isUnique" :label="$t('is_unique')">
                    <RadioGroup v-model="item.form.isUnique">
                      <Radio :disabled="item.form.status === 'decommissioned'" label="yes">Yes</Radio>
                      <Radio :disabled="item.form.status === 'decommissioned'" label="no">No</Radio>
                    </RadioGroup>
                  </FormItem>
                  <FormItem prop="isAuto" :label="$t('is_auto')">
                    <RadioGroup v-model="item.form.isAuto">
                      <Radio :disabled="item.form.status === 'decommissioned'" label="yes">Yes</Radio>
                      <Radio :disabled="item.form.status === 'decommissioned'" label="no">No</Radio>
                    </RadioGroup>
                  </FormItem>
                  <FormItem prop="autoFillRule" v-if="item.form.isAuto === 'yes'" :label="$t('auto_fill_rule')">
                    <AutoFill
                      :allCiTypes="allCiTypesWithAttr"
                      :rootCiTypeId="item.ciTypeId"
                      :specialDelimiters="specialDelimiters"
                      v-model="item.form.autoFillRule"
                      :disabled="item.form.status === 'decommissioned'"
                    ></AutoFill>
                  </FormItem>
                  <FormItem
                    class="no-need-validation"
                    v-if="
                      item.form.inputType === 'ref' ||
                        item.form.inputType === 'select' ||
                        item.form.inputType === 'multiRef' ||
                        item.form.inputType === 'multiSelect'
                    "
                    :label="$t('filter_rule')"
                  >
                    <FilterRule
                      :allLayers="source"
                      :filterAttr="item"
                      :rootCiTypeId="item.ciTypeId"
                      v-model="item.form.filterRule"
                      :disabled="item.form.status === 'decommissioned'"
                    ></FilterRule>
                  </FormItem>
                  <FormItem>
                    <Button
                      type="primary"
                      small
                      @click="applyAttr(item.ciTypeAttrId, item.form)"
                      :loading="buttonLoading.applyAttr"
                      style="float: right"
                      :disabled="item.form.status === 'decommissioned'"
                      >{{ $t('submit') }}</Button
                    >
                    <Button
                      type="primary"
                      small
                      @click="saveAttr(item.ciTypeAttrId, item.form)"
                      :loading="buttonLoading.saveAttr"
                      style="float: right; margin-right: 20px"
                      :disabled="item.form.status !== 'notCreated'"
                      >{{ $t('save_draft') }}</Button
                    >
                  </FormItem>
                </Form>
              </div>
            </Panel>
          </Collapse>
        </div>
      </Card>
      <Modal
        v-model="isAddNewAttrModalVisible"
        :title="$t('new_ci_attribute')"
        @on-visible-change="addAttrModalToggle"
        footer-hide
      >
        <Form
          class="validation-form"
          ref="ciAttrForm"
          :model="addNewAttrForm"
          label-position="right"
          :label-width="150"
        >
          <FormItem :label="$t('ci_attribute_name')" prop="name">
            <Input v-model="addNewAttrForm.name"></Input>
          </FormItem>
          <FormItem prop="propertyName" :label="$t('ci_attribute_id')">
            <Input v-model="addNewAttrForm.propertyName"></Input>
          </FormItem>
          <FormItem :label="$t('search_filter_number')">
            <InputNumber :min="0" v-model="addNewAttrForm.searchSeqNo"></InputNumber>
          </FormItem>
          <FormItem prop="inputType" :label="$t('data_type')">
            <Select v-model="addNewAttrForm.inputType" @on-change="onInputTypeChange($event, false)">
              <Option v-for="item in allInputTypes" :value="item" :key="item">{{ item }}</Option>
            </Select>
          </FormItem>
          <FormItem
            v-if="addNewAttrForm.inputType === 'text' || addNewAttrForm.inputType === 'textArea'"
            prop="regularExpressionRule"
            :label="$t('regular_rule')"
          >
            <Input v-model="addNewAttrForm.regularExpressionRule"></Input>
          </FormItem>
          <FormItem prop="propertyType" :label="$t('real_type')">
            <Input v-model="addNewAttrForm.propertyType" disabled></Input>
          </FormItem>
          <FormItem
            prop="length"
            :label="$t('length')"
            v-if="
              addNewAttrForm.inputType === 'text' ||
                addNewAttrForm.inputType === 'textArea' ||
                addNewAttrForm.inputType === 'number'
            "
          >
            <InputNumber :min="1" v-model="addNewAttrForm.length"></InputNumber>
          </FormItem>
          <FormItem
            prop="referenceId"
            v-if="addNewAttrForm.inputType === 'ref' || addNewAttrForm.inputType === 'multiRef'"
            :label="$t('reference_select')"
          >
            <Select v-model="addNewAttrForm.referenceId">
              <Option v-for="item in allCiTypes" :value="item.ciTypeId" :key="item.ciTypeId">{{ item.name }}</Option>
            </Select>
          </FormItem>
          <FormItem
            prop="referenceName"
            v-if="addNewAttrForm.inputType === 'ref' || addNewAttrForm.inputType === 'multiRef'"
            :label="$t('reference_name')"
          >
            <Input v-model="addNewAttrForm.referenceName"></Input>
          </FormItem>
          <FormItem
            prop="referenceType"
            v-if="addNewAttrForm.inputType === 'ref' || addNewAttrForm.inputType === 'multiRef'"
            :label="$t('reference_type')"
          >
            <Select v-model="addNewAttrForm.referenceType">
              <Option v-for="item in allReferenceTypes" :value="item.codeId" :key="item.codeId">{{
                item.value
              }}</Option>
            </Select>
          </FormItem>
          <FormItem
            prop="referenceId"
            v-if="addNewAttrForm.inputType === 'select' || addNewAttrForm.inputType === 'multiSelect'"
            :label="$t('select')"
          >
            <Select clearable v-model="addNewAttrForm.referenceId">
              <span slot="prefix" @click.stop.prevent="openEnumGroupModal(null)">@+</span>
              <Option v-for="item in currentSelectedCIAttrEnum" :value="item.catId" :key="item.catId">
                {{ `[${item.catTypeId === 2 ? 'common' : 'private'}] ${item.catName}` }}
                <span style="float:right">
                  <Button
                    @click.stop.prevent="openEnumGroupModal(item)"
                    icon="ios-build"
                    type="primary"
                    size="small"
                  ></Button>
                </span>
              </Option>
            </Select>
          </FormItem>
          <FormItem prop="isRefreshable" :label="$t('is_refreshable')">
            <RadioGroup v-model="addNewAttrForm.isRefreshable">
              <Radio label="yes">Yes</Radio>
              <Radio label="no">No</Radio>
            </RadioGroup>
          </FormItem>
          <FormItem prop="isDisplayed" :label="$t('is_displayed')">
            <RadioGroup v-model="addNewAttrForm.isDisplayed">
              <Radio label="yes">Yes</Radio>
              <Radio label="no">No</Radio>
            </RadioGroup>
          </FormItem>
          <FormItem
            prop="isAccessControlled"
            v-if="
              addNewAttrForm.inputType === 'select' ||
                addNewAttrForm.inputType === 'multiSelect' ||
                addNewAttrForm.inputType === 'ref' ||
                addNewAttrForm.inputType === 'multiRef'
            "
            :label="$t('is_access_controlled')"
          >
            <RadioGroup v-model="addNewAttrForm.isAccessControlled">
              <Radio label="yes">Yes</Radio>
              <Radio label="no">No</Radio>
            </RadioGroup>
          </FormItem>
          <FormItem prop="isNullable" :label="$t('is_nullable')">
            <RadioGroup v-model="addNewAttrForm.isNullable">
              <Radio label="yes">Yes</Radio>
              <Radio label="no">No</Radio>
            </RadioGroup>
          </FormItem>
          <FormItem prop="isEditable" :label="$t('is_editable')">
            <RadioGroup v-model="addNewAttrForm.isEditable">
              <Radio label="yes">Yes</Radio>
              <Radio label="no">No</Radio>
            </RadioGroup>
          </FormItem>
          <FormItem prop="isUnique" :label="$t('is_unique')">
            <RadioGroup v-model="addNewAttrForm.isUnique">
              <Radio label="yes">Yes</Radio>
              <Radio label="no">No</Radio>
            </RadioGroup>
          </FormItem>
          <FormItem prop="isAuto" :label="$t('is_auto')">
            <RadioGroup v-model="addNewAttrForm.isAuto">
              <Radio label="yes">Yes</Radio>
              <Radio label="no">No</Radio>
            </RadioGroup>
          </FormItem>
          <FormItem prop="layerId" v-if="addNewAttrForm.isAuto === 'yes'" :label="$t('auto_fill_rule')">
            <AutoFill
              :allCiTypes="allCiTypesWithAttr"
              :rootCiTypeId="currentSelectedCI.ciTypeId"
              :specialDelimiters="specialDelimiters"
              v-model="addNewAttrForm.autoFillRule"
            ></AutoFill>
          </FormItem>
          <FormItem>
            <Button type="primary" small @click="addNewAttr" :loading="buttonLoading.addNewAttr" style="float: right">{{
              $t('submit')
            }}</Button>
          </FormItem>
        </Form>
      </Modal>

      <Modal
        v-model="isEditLayerNameModalVisible"
        :title="$t('edit_layer_name')"
        @on-ok="editLayerName"
        @on-cancel="() => {}"
      >
        <Input v-model="updatedLayerNameValue.code" :placeholder="$t('input_placeholder')" />
      </Modal>

      <Modal v-model="isEditCINameModalVisible" :title="$t('edit_ci_name')" @on-ok="editCIName" @on-cancel="() => {}">
        <Input v-model="updatedCINameValue.name" :placeholder="$t('input_placeholder')" />
      </Modal>
      <enumGroupModal
        @hideHandler="hideEnumGroupModal"
        @getAllEnums="getEnum"
        :allEnumCategoryTypes="allEnumCategoryTypes"
        :enumGroupVisible="enumGroupModalVisible"
        :currentCiType="currentSelectedCI"
        :category="currentCategory"
        :allCategory="allEnumCategories"
      ></enumGroupModal>
    </Col>
    <!-- eslint-disable-next-line -->
    <Col span="6" offset="0" class="func-wrapper" v-else>
      <Card>
        <Row slot="title">
          <p>{{ $t('input_area') }}</p>
        </Row>
        <p>{{ $t('architecture_diagram_operation_tips') }}</p>
      </Card>
    </Col>
  </Row>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line
import * as d3Graphviz from 'd3-graphviz'
import { addEvent } from '../util/event.js'
import { formatString } from '../util/format.js'
import {
  getAllCITypesByLayerWithAttr,
  getAllLayers,
  createLayer,
  deleteCITypeByID,
  deleteAttr,
  updateCIType,
  applyCiTypes,
  createNewCIType,
  updateLayer,
  swapLayerPosition,
  createNewCIAttr,
  updateCIAttr,
  deleteLayer,
  swapCiTypeAttributePosition,
  getAllCITypes,
  getAllInputTypes,
  getEnumByCIType,
  getAllSystemEnumCodes,
  getTableStatus,
  applyCIAttr,
  getAllEnumCategoryTypes,
  getAllEnumCategories,
  implementCiType,
  implementCiAttr,
  getEnumCategoriesByTypeId,
  getSpecialConnector
} from '@/api/server'
import STATUS_LIST from '@/const/graph-status-list.js'
import { PROPERTY_TYPE_MAP } from '@/const/data-types.js'
import { setHeaders, baseURL } from '@/api/base.js'
import enumGroupModal from './components/enum-group-modal'
import AutoFill from '../components/auto-fill.js'
import FilterRule from '../components/filter-rule'

const defaultCiTypePNG = require('@/assets/ci-type-default.png')

export default {
  components: {
    enumGroupModal,
    AutoFill,
    FilterRule
  },
  data () {
    return {
      baseURL,
      imgs: new Array(26),
      source: {},
      layers: [],
      graph: {},
      currentSelectedLayer: {},
      currentSelectedCI: {},
      currentCategory: null,
      currentSelectedCIAttrEnum: [],
      allEnumCategoryTypes: [],
      allEnumCategories: [],
      isLayerSelected: false,
      nodeName: '',
      g: null,
      n: null,
      statusList: [],
      selectedStatus: ['notCreated', 'created'],
      allStatus: STATUS_LIST.map(_ => _.value),
      newLayer: {
        addNewLayerCode: '',
        addNewLayerValue: '',
        addNewLayerDescription: ''
      },
      isAddNewLayerModalVisible: false,
      isEditLayerNameModalVisible: false,
      isAddNewCITypeModalVisible: false,
      isEditCINameModalVisible: false,
      isAddNewAttrModalVisible: false,
      enumGroupModalVisible: false,
      updatedLayerNameValue: {},
      updatedCINameValue: {},
      currentSelectLayerChildren: [],
      currentSelectedCIChildren: [],
      addNewCITypeForm: {
        imageFileId: 1
      },
      addNewAttrForm: {
        searchSeqNo: 0,
        isAccessControlled: 'no',
        isRefreshable: 'no',
        isDisplayed: 'no',
        isNullable: 'no',
        isAuto: 'no',
        isEditable: 'yes',
        isUnique: 'no'
      },
      allCiTypes: [],
      allCiTypesWithAttr: [],
      specialDelimiters: [],
      allInputTypes: [],
      allReferenceTypes: [],
      selectedCIAttrIsSystem: false,
      buttonLoading: {
        newLayer: false,
        upLayer: false,
        downLayer: false,
        revertCI: false,
        saveCiType: false,
        submitCiType: false,
        addNewCIType: false,
        addNewAttrHandler: false,
        moveUpAttr: false,
        moveDownAttr: false,
        revertCIAttr: false,
        applyAttr: false,
        saveAttr: false,
        addNewAttr: false
      }
    }
  },
  methods: {
    addLayerModalToggle (isShow) {
      if (!isShow) {
        this.newLayer = {
          addNewLayerCode: '',
          addNewLayerValue: '',
          addNewLayerDescription: ''
        }
      }
    },
    addCiTypeModalToggle (isShow) {
      if (!isShow) {
        this.addNewCITypeForm = {
          layerId: this.addNewCITypeForm.layerId,
          imageFileId: 1
        }
      }
    },
    addAttrModalToggle (isShow) {
      if (!isShow) {
        this.addNewAttrForm = {
          isAccessControlled: 'no',
          isAuto: 'no',
          isDisplayed: 'no',
          isEditable: 'yes',
          isUnique: 'no',
          isNullable: 'no',
          isRefreshable: 'no',
          searchSeqNo: 0
        }
      }
    },
    openEnumGroupModal (val) {
      this.currentCategory = val
      this.enumGroupModalVisible = true
    },
    hideEnumGroupModal (val) {
      this.enumGroupModalVisible = false
    },
    async initGraph (status = []) {
      let graph

      const graphEl = document.getElementById('graph')
      const initEvent = () => {
        graph = d3.select('#graph')
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)

        this.graph.graphviz = graph
          .graphviz()
          .zoom(true)
          .height(window.innerHeight - 210)
          .width(graphEl.offsetWidth - 16)
          .attributer(function (d) {
            if (d.attributes.class === 'edge') {
              const keys = d.key.split('->')
              const from = keys[0].trim()
              const to = keys[1].trim()
              d.attributes.from = from
              d.attributes.to = to
            }

            if (d.tag === 'text') {
              const key = d.children[0].text
              d3.select(this).attr('text-key', key)
            }
          })
      }

      let layerResponse = await getAllLayers()
      if (layerResponse.statusCode === 'OK') {
        let tempLayer = layerResponse.data
          .filter(i => i.status === 'active')
          .map(_ => {
            return { name: _.value, layerId: _.codeId, ..._ }
          })
        this.layers = tempLayer.sort((a, b) => {
          return a.seqNo - b.seqNo
        })
        let ciResponse = await getAllCITypesByLayerWithAttr(this.selectedStatus)
        if (ciResponse.statusCode === 'OK') {
          this.source = []
          this.source = ciResponse.data
          this.source.forEach(_ => {
            _.ciTypes &&
              _.ciTypes.forEach(async i => {
                let imgFileSource =
                  i.imageFileId === 0 || i.imageFileId === undefined
                    ? defaultCiTypePNG.substring(0, defaultCiTypePNG.length - 4)
                    : `${baseURL}/files/${i.imageFileId}`
                this.$set(i, 'form', {
                  ...i,
                  imgSource: imgFileSource,
                  imgUploadURL: `${baseURL}/ci-types/${i.ciTypeId}/icon`
                })
                i.attributes &&
                  i.attributes.forEach(j => {
                    this.$set(j, 'form', {
                      ...j,
                      isRefreshable: j.isRefreshable ? 'yes' : 'no',
                      isDisplayed: j.isDisplayed ? 'yes' : 'no',
                      isAccessControlled: j.isAccessControlled ? 'yes' : 'no',
                      isNullable: j.isNullable ? 'yes' : 'no',
                      isAuto: j.isAuto ? 'yes' : 'no',
                      isEditable: j.isEditable ? 'yes' : 'no',
                      isUnique: j.isUnique ? 'yes' : 'no',
                      searchSeqNo: j.searchSeqNo || 0
                    })
                  })

                this.renderRightPanels()
              })
          })
          let uploadToken = document.cookie.split(';').find(i => i.indexOf('XSRF-TOKEN') !== -1)
          setHeaders({
            'X-XSRF-TOKEN': uploadToken && uploadToken.split('=')[1]
          })
          initEvent()
          this.renderGraph(ciResponse.data)
        }
      }
    },
    genDOT (data) {
      let nodes = []
      data.forEach(_ => {
        if (_.ciTypes) nodes = nodes.concat(_.ciTypes)
      })
      var dots = [
        'digraph  {',
        'bgcolor="transparent";',
        'Node [fontname=Arial, shape="ellipse", fixedsize="true", width="1.1", height="1.1", color="transparent" ,fontsize=12];',
        'Edge [fontname=Arial, minlen="1", color="#7f8fa6", fontsize=10];',
        'ranksep = 1.1; nodesep=.7; size = "11,8"; rankdir=TB'
      ]
      let layerTag = `node [];`

      // generate group
      let tempClusterObjForGraph = {}
      let tempClusterAryForGraph = []
      this.layers.map((_, index) => {
        if (index !== this.layers.length - 1) {
          layerTag += `"layer_${_.layerId}"->`
        } else {
          layerTag += `"layer_${_.layerId}"`
        }
        tempClusterObjForGraph[index] = [
          `{ rank=same; "layer_${_.layerId}"[id="layerId_${_.layerId}",class="layer",label="${_.name}",tooltip="${_.name}"];`
        ]
        nodes.length > 0 &&
          nodes.forEach((node, nodeIndex) => {
            if (node.layerId === _.layerId) {
              let fontcolor = node.status === 'notCreated' ? '#10a34e' : 'black'
              tempClusterObjForGraph[index].push(
                `"ci_${node.ciTypeId}"[id="${node.ciTypeId}",label="${node.name}",tooltip="${node.name}",class="ci",fontcolor="${fontcolor}", image="${node.form.imgSource}.png", labelloc="b"]`
              )
            }
            if (nodeIndex === nodes.length - 1) {
              tempClusterObjForGraph[index].push('} ')
            }
          })
        if (nodes.length === 0) {
          tempClusterObjForGraph[index].push('} ')
        }
        tempClusterAryForGraph.push(tempClusterObjForGraph[index].join(''))
      })
      dots.push(tempClusterAryForGraph.join(''))
      dots.push('{' + layerTag + '[style=invis]}')

      // generate edges
      nodes.forEach(node => {
        node.attributes &&
          node.attributes.forEach(attr => {
            if (attr.inputType === 'ref' || attr.inputType === 'multiRef') {
              var target = nodes.find(_ => _.ciTypeId === attr.referenceId)
              if (target) {
                dots.push(this.genEdge(nodes, node, attr))
              }
            }
          })
      })
      dots.push('}')
      return dots.join('')
    },
    genEdge (nodes, from, to) {
      const target = nodes.find(_ => _.ciTypeId === to.referenceId)
      let labels = to.referenceName ? to.referenceName.trim() : ''
      return `"ci_${from.ciTypeId}"->"ci_${target.ciTypeId}"[taillabel="${labels}",labeldistance=3];`
    },
    shadeAll () {
      d3.selectAll('g path')
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
      d3.selectAll('g polygon')
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
        .attr('fill', '#7f8fa6')
        .attr('fill-opacity', '.2')
      d3.selectAll('.edge text').attr('fill', '#7f8fa6')
    },
    colorNode (nodeName) {
      d3.selectAll('g[from="' + nodeName + '"] path')
        .attr('stroke', 'red')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[from="' + nodeName + '"] text').attr('fill', 'red')
      d3.selectAll('g[from="' + nodeName + '"] polygon')
        .attr('stroke', 'red')
        .attr('fill', 'red')
        .attr('fill-opacity', '1')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[to="' + nodeName + '"] path')
        .attr('stroke', 'green')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[to="' + nodeName + '"] text').attr('fill', 'green')
      d3.selectAll('g[to="' + nodeName + '"] polygon')
        .attr('stroke', 'green')
        .attr('fill', 'green')
        .attr('fill-opacity', '1')
        .attr('stroke-opacity', '1')
    },

    loadImage (nodesString) {
      ;(nodesString.match(/image=[^,]*(files\/\d*|png)/g) || [])
        .filter((value, index, self) => {
          return self.indexOf(value) === index
        })
        .map(keyvaluepaire => keyvaluepaire.substr(7))
        .forEach(image => {
          this.graph.graphviz.addImage(image, '48px', '48px')
        })
    },
    renderGraph (data) {
      let nodesString = this.genDOT(data)
      this.loadImage(nodesString)
      this.graph.graphviz.renderDot(nodesString)
      addEvent('svg', 'mouseover', e => {
        this.shadeAll()
        e.preventDefault()
        e.stopPropagation()
      })
      this.shadeAll()
      addEvent('.node', 'mouseover', async e => {
        e.preventDefault()
        e.stopPropagation()
        d3.selectAll('g').attr('cursor', 'pointer')

        this.g = e.currentTarget
        this.nodeName = this.g.children[0].innerHTML.trim()
        this.shadeAll()
        this.colorNode(this.nodeName)
      })
      addEvent('.node', 'click', async e => {
        this.n = e.currentTarget
        this.isLayerSelected = this.g.getAttribute('class').indexOf('layer') >= 0
        this.renderRightPanels()
      })
    },
    renderRightPanels () {
      if (!this.nodeName) return
      if (this.isLayerSelected) {
        this.currentSelectedLayer = this.layers.find(_ => _.layerId === +this.n.id.split('_')[1])
        this.updatedLayerNameValue = {
          codeId: this.currentSelectedLayer.layerId,
          code: this.currentSelectedLayer.name
        }
        this.handleLayerSelect(this.currentSelectedLayer.layerId)
      } else {
        this.source.forEach(_ => {
          _.ciTypes &&
            _.ciTypes.forEach(i => {
              if (i.ciTypeId && i.ciTypeId === +this.n.id) {
                this.currentSelectedCI = i
                this.currentSelectedCIChildren =
                  (i.attributes &&
                    i.attributes.sort((a, b) => {
                      return a.displaySeqNo - b.displaySeqNo
                    })) ||
                  []
              }
            })
        })
        this.updatedCINameValue = {
          ciTypeId: parseInt(this.n.id),
          name: this.currentSelectedCI.name
        }
        this.getAllEnumTypes()
        this.getAllEnumCategories()
      }
    },
    async getAllEnumCategories () {
      if (this.allEnumCategories.length === 0) {
        const { data, statusCode } = await getAllEnumCategories()
        if (statusCode === 'OK') {
          this.allEnumCategories = data.contents
        }
      }
    },
    async getAllEnumTypes () {
      if (this.allEnumCategoryTypes.length === 0) {
        const { data, statusCode } = await getAllEnumCategoryTypes()
        if (statusCode === 'OK') {
          this.allEnumCategoryTypes = data
        }
      }
    },
    handleLayerSelect (layerId) {
      this.currentSelectLayerChildren = this.source.find(_ => _.codeId === layerId)
      this.addNewCITypeForm.layerId = this.currentSelectLayerChildren.codeId
    },
    handleStatusChange (value) {
      this.initGraph(value)
    },
    onCIAttrCollapeOpen (val) {
      this.currentSelectedCIChildren.forEach((_, index) => {
        if (_.ciTypeAttrId === +val[0] && (_.inputType === 'select' || _.inputType === 'multiSelect')) {
          this.selectedCIAttrIsSystem = _.isSystem
          this.getEnum()
        }
      })
    },
    async getEnum (isNewAdd = false) {
      const SYS_ENUM_TYPE_ID = 1
      const res =
        this.selectedCIAttrIsSystem && !isNewAdd
          ? await getEnumCategoriesByTypeId(SYS_ENUM_TYPE_ID)
          : await getEnumByCIType(this.currentSelectedCI.ciTypeId)
      this.buttonLoading.addNewAttrHandler = false
      if (res.statusCode === 'OK') {
        let enumList = []
        enumList =
          this.selectedCIAttrIsSystem && !isNewAdd
            ? res.data
            : enumList.concat(res.data.private || []).concat(res.data.common || [])
        this.currentSelectedCIAttrEnum = enumList
      }
    },
    async onInputTypeChange (value, isDiabled) {
      this.addNewAttrForm.propertyType = PROPERTY_TYPE_MAP[value]
      if (value === 'select' || (value === 'multiSelect' && !isDiabled)) {
        this.getEnum(true)
      }
    },
    addNewLayer (formName) {
      this.$refs[formName].validate(async valid => {
        if (valid) {
          this.buttonLoading.newLayer = true
          let payload = {
            code: this.newLayer.addNewLayerCode,
            codeDescription: this.newLayer.addNewLayerDescription,
            value: this.newLayer.addNewLayerValue
          }
          let res = await createLayer(payload)
          this.buttonLoading.newLayer = false
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('add_layer_success'),
              desc: res.message
            })
          }
          this.isAddNewLayerModalVisible = false
          this.initGraph()
        }
      })
    },
    async editLayerName () {
      let res = await updateLayer([
        {
          codeId: this.updatedLayerNameValue.codeId,
          value: this.updatedLayerNameValue.code
        }
      ])
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('edit_layer_name_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async upLayer (id) {
      this.buttonLoading.upLayer = true
      let currentIndex = this.layers.map(i => i.codeId).indexOf(id)
      if (!this.layers[currentIndex - 1]) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('is_first_layer')
        })
        return
      }
      let targetID = this.layers[currentIndex - 1].codeId
      let res = await swapLayerPosition(id, targetID)
      this.buttonLoading.upLayer = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('move_up_layer_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async downLayer (id) {
      this.buttonLoading.downLayer = true
      let currentIndex = this.layers.map(i => i.codeId).indexOf(id)
      if (!this.layers[currentIndex + 1]) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('is_last_layer')
        })
        return
      }
      let targetID = this.layers[currentIndex + 1].codeId
      let res = await swapLayerPosition(id, targetID)
      this.buttonLoading.downLayer = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('move_down_layer_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async deleteLayer (id) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        loading: true,
        'z-index': 1000000,
        onOk: async () => {
          const { statusCode, message } = await deleteLayer(id)
          this.$Modal.remove()
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('delete_layer_success'),
              desc: message
            })
            this.reRenderGraph()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async revertCI (ciTypeId) {
      this.buttonLoading.revertCI = true
      let res = await implementCiType(ciTypeId, 'revert')
      this.buttonLoading.revertCI = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('revert_ci_type_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async revertCIAttr (attrId) {
      this.buttonLoading.revertCIAttr = true
      let res = await implementCiAttr(this.currentSelectedCI.ciTypeId, attrId, 'revert')
      this.buttonLoading.revertCIAttr = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('revert_ci_attribute_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async editCIName () {
      let res = await updateCIType(this.updatedCINameValue.ciTypeId, this.updatedCINameValue)
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('update_ci_name_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async deleteCI (id, status) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        loading: true,
        'z-index': 1000000,
        onOk: async () => {
          let res = status === 'notCreated' ? await deleteCITypeByID(id) : await implementCiType(id, 'deco')
          this.$Modal.remove()
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: status === 'notCreated' ? 'CI delete' : 'CI decomission',
              desc: res.message
            })
            this.initGraph()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async deleteCIAttr (id, status) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        loading: true,
        onOk: async () => {
          let res =
            status === 'notCreated'
              ? await deleteAttr(this.currentSelectedCI.ciTypeId, id)
              : await implementCiAttr(this.currentSelectedCI.ciTypeId, id, 'deco')
          this.$Modal.remove()
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: status === 'notCreated' ? 'Delete CI Attr Successful' : 'Deprecate CI Attr Successful',
              desc: res.message
            })
            this.initGraph()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async saveCiType (id, form) {
      this.buttonLoading.saveCiType = true
      delete form.attributes
      delete form.tableName
      delete form.status
      delete form.imgSource
      delete form.imgUploadURL
      let res = await updateCIType(id, {
        ...form,
        callbackId: '10000001'
      })
      this.buttonLoading.saveCiType = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('save_ci_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    addNewCIType () {
      this.$refs['addNewCITypeForm'].validate(async valid => {
        if (valid) {
          this.buttonLoading.addNewCIType = true
          const payload = { ...this.addNewCITypeForm, callbackId: '10000001' }
          let res = await createNewCIType(payload)
          this.buttonLoading.addNewCIType = false
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('add_ci_type_success'),
              desc: res.message
            })
            this.resetAddNewCITypeForm()
            this.getAllReferenceTypesList()
            this.isAddNewCITypeModalVisible = false
            this.initGraph()
            this.getAllEnumTypes()
          }
        }
      })
    },
    resetAddNewCITypeForm () {
      this.addNewCITypeForm = {
        name: '',
        tableName: '',
        layerId: '',
        description: '',
        imageFileId: 1
      }
    },
    async submitCiType (id, form) {
      this.buttonLoading.submitCiType = true
      const isNotCreated = form.status === 'notCreated'
      delete form.attributes
      delete form.tableName
      delete form.status
      delete form.imgSource
      delete form.imgUploadURL
      let res = isNotCreated
        ? await applyCiTypes(id)
        : await updateCIType(id, {
          ...form
        })
      this.buttonLoading.submitCiType = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('apply_ci_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async moveUpAttr (id) {
      let currentIndex = this.currentSelectedCIChildren.map(i => i.ciTypeAttrId).indexOf(id)
      if (!this.currentSelectedCIChildren[currentIndex - 1]) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('is_first_one')
        })
        return
      }
      this.buttonLoading.moveUpAttr = true
      let targetID = this.currentSelectedCIChildren[currentIndex - 1].ciTypeAttrId
      let res = await swapCiTypeAttributePosition(this.currentSelectedCI.ciTypeId, id, targetID)
      this.buttonLoading.moveUpAttr = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('move_up_ci_attr_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async moveDownAttr (id) {
      let currentIndex = this.currentSelectedCIChildren.map(i => i.ciTypeAttrId).indexOf(id)
      if (!this.currentSelectedCIChildren[currentIndex + 1]) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('is_last_one')
        })
        return
      }
      this.buttonLoading.moveDownAttr = true
      let targetID = this.currentSelectedCIChildren[currentIndex + 1].ciTypeAttrId
      let res = await swapCiTypeAttributePosition(this.currentSelectedCI.ciTypeId, id, targetID)
      this.buttonLoading.moveDownAttr = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('move_down_ci_attr_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async addNewAttr (id) {
      this.buttonLoading.addNewAttr = true
      const payload = {
        ...this.addNewAttrForm,
        length: this.addNewAttrForm.length || 1,
        isRefreshable: this.addNewAttrForm.isRefreshable === 'yes',
        isDisplayed: this.addNewAttrForm.isDisplayed === 'yes',
        isAccessControlled: this.addNewAttrForm.isAccessControlled === 'yes',
        isNullable: this.addNewAttrForm.isNullable === 'yes',
        isAuto: this.addNewAttrForm.isAuto === 'yes',
        isEditable: this.addNewAttrForm.isEditable === 'yes',
        isUnique: this.addNewAttrForm.isUnique === 'yes',
        callbackId: '10000001'
      }
      let res = await createNewCIAttr(this.currentSelectedCI.ciTypeId, payload)
      this.buttonLoading.addNewAttr = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_ci_attr_success'),
          desc: res.message
        })
        this.resetAddAttrForm()
        this.isAddNewAttrModalVisible = false
        this.initGraph()
      }
    },
    addNewAttrHandler () {
      this.buttonLoading.addNewAttrHandler = true
      this.getEnum(true)
      this.isAddNewAttrModalVisible = true
    },
    resetAddAttrForm () {
      this.addNewAttrForm = {}
    },
    async saveAttr (ciTypeAttrId, form) {
      this.buttonLoading.saveAttr = true
      const isSelectOrRef =
        form.inputType === 'select' ||
        form.inputType === 'ref' ||
        form.inputType === 'multiSelect' ||
        form.inputType === 'multiRef'
      let payload = {
        ...form,
        length: form.length || 1,
        isRefreshable: form.isRefreshable === 'yes',
        isDisplayed: form.isDisplayed === 'yes',
        isAccessControlled: isSelectOrRef && form.isAccessControlled === 'yes',
        isNullable: form.isNullable === 'yes',
        isAuto: form.isAuto === 'yes',
        isEditable: form.isEditable === 'yes',
        isUnique: form.isUnique === 'yes'
      }
      delete payload.status
      delete payload.ciType
      let res = await updateCIAttr(this.currentSelectedCI.ciTypeId, ciTypeAttrId, payload)
      this.buttonLoading.saveAttr = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('save_ci_attr_success'),
          desc: res.message
        })
        this.initGraph()
      }
    },
    async applyAttr (ciTypeAttrId, form) {
      const isSelectOrRef =
        form.inputType === 'select' ||
        form.inputType === 'ref' ||
        form.inputType === 'multiSelect' ||
        form.inputType === 'multiRef'
      this.buttonLoading.applyAttr = true
      let updateRes = await updateCIAttr(this.currentSelectedCI.ciTypeId, ciTypeAttrId, {
        ...form,
        length: form.length || 1,
        isRefreshable: form.isRefreshable === 'yes',
        isDisplayed: form.isDisplayed === 'yes',
        isAccessControlled: isSelectOrRef && form.isAccessControlled === 'yes',
        isNullable: form.isNullable === 'yes',
        isAuto: form.isAuto === 'yes',
        isEditable: form.isEditable === 'yes',
        isUnique: form.isUnique === 'yes'
      })
      if (updateRes.statusCode === 'OK') {
        let applyRes = await applyCIAttr(this.currentSelectedCI.ciTypeId, [ciTypeAttrId])
        this.buttonLoading.applyAttr = false
        if (applyRes.statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('apply_ci_attr_success'),
            desc: applyRes.message
          })
          this.initGraph()
        }
      } else {
        tis.buttonLoading.applyAttr = false
      }
    },

    handleNewCITypeUploadImgSuccess (res, file) {
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('icon_upload_success'),
          desc: res.message
        })

        this.addNewCITypeForm.imageFileId = res.data.id
      } else {
        this.$Notice.warning({
          title: this.$t('icon_upload_failed'),
          desc: res.message
        })
      }
    },
    handleUploadImgSuccess (res, file) {
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('icon_upload_success'),
          desc: res.message
        })
        this.initGraph(this.selectedStatus)
      } else {
        this.$Notice.warning({
          title: this.$t('icon_upload_failed'),
          desc: res.message
        })
      }
    },
    handleFormatError (file) {
      this.$Notice.warning({
        title: this.$t('file_format_incorrect'),
        desc: formatString(this.$t('file_format_incorrect_message'), file.name)
      })
    },
    handleMaxSize (file) {
      this.$Notice.warning({
        title: 'Exceeding file size limit',
        desc: formatString(this.$t('file_oversize_message'), file.name)
      })
    },
    async getAllCITypesList () {
      const res = await getAllCITypes()
      if (res.statusCode === 'OK') {
        this.allCiTypes = res.data
      }
    },
    async getAllCiTypeWithAttr () {
      const res = await getAllCITypesByLayerWithAttr(['notCreated', 'created', 'decommissioned', 'dirty'])
      if (res.statusCode === 'OK') {
        let allCiTypesWithAttr = []
        res.data.forEach(layer => {
          layer.ciTypes &&
            layer.ciTypes.forEach(_ => {
              allCiTypesWithAttr.push(_)
            })
        })
        this.allCiTypesWithAttr = allCiTypesWithAttr
      }
    },
    async getSpecialConnector () {
      const res = await getSpecialConnector()
      if (res.statusCode === 'OK') {
        this.specialDelimiters = res.data
      }
    },
    async getAllInputTypesList () {
      const res = await getAllInputTypes()
      if (res.statusCode === 'OK') {
        this.allInputTypes = res.data
      }
    },
    async getAllReferenceTypesList () {
      const payload = {
        filters: [{ name: 'cat.catName', operator: 'eq', value: 'ci_attr_ref_type' }],
        paging: false
      }
      const res = await getAllSystemEnumCodes(payload)
      if (res.statusCode === 'OK') {
        this.allReferenceTypes = res.data.contents
      }
    },
    async getTableStatusList () {
      const res = await getTableStatus()
      if (res.statusCode === 'OK') {
        this.statusList = res.data
      }
    },
    reRenderGraph () {
      this.nodeName = ''
      this.currentSelectedLayer = {}
      this.currentSelectedCI = {}
      this.getAllCITypesList()
      this.initGraph()
    }
  },
  mounted () {
    this.initGraph()
    this.getAllCITypesList()
    this.getAllInputTypesList()
    this.getAllReferenceTypesList()
    this.getTableStatusList()
    this.getAllCiTypeWithAttr()
    this.getSpecialConnector()
  },
  computed: {
    setUploadActionHeader () {
      let uploadToken = document.cookie.split(';').find(i => i.indexOf('XSRF-TOKEN') !== -1)
      return {
        'X-XSRF-TOKEN': uploadToken && uploadToken.split('=')[1]
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.attrContainer {
  overflow: auto;
  height: calc(100vh - 205px);
}
.ivu-card-head p {
  height: 30px;
  line-height: 30px;
}
.graph-container {
  overflow: auto;
  svg {
    g {
      cursor: pointer !important;
    }
  }
}

.decommissionedLabel {
  text-decoration: line-through;
}
.filter-title {
  margin-right: 10px;
}
.margin-left {
  margin-left: 20px;
}
.margin-right {
  margin-right: 20px;
}
.collapse-row-title {
  float: right;
  width: calc(100% - 30px);
}
.ci-type-header-title {
  display: block;
  float: left;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  width: calc(100% - 55px);
}
.attr-header-title {
  display: block;
  float: left;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  width: calc(100% - 120px);
}
.func-wrapper {
  .header-buttons-container {
    float: right;
  }
}
</style>
