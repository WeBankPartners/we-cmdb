<template>
  <Row>
    <Col span="19">
      <div style="padding-right: 20px">
        <Card class="cmdb-model-management-left-card" style="height: calc(100vh - 108px);">
          <Row slot="title">
            <Col span="24">
              <div style="display: flex；flex-wrap: wrap">
                <p class="search-item">
                  <span class="filter-title">{{ $t('change_group') }}</span>
                  <Select multiple filterable :max-tag-count="1" v-model="currentciGroup" style="flex: 1;width:150px">
                    <Option v-for="item in originciGroupList" :value="item.codeId" :key="item.codeId">
                      {{ item.value }}
                    </Option>
                  </Select>
                  <Tooltip :content="$t('add_group')" placement="top-start">
                    <Button size="small" @click="openLayerModal('level')" class="btn-add-c" icon="md-add"></Button>
                  </Tooltip>
                </p>
                <p class="search-item">
                  <span class="filter-title">{{ $t('change_layer') }}</span>
                  <Select multiple filterable :max-tag-count="1" v-model="currentciLayer" style="flex: 1;width:140px">
                    <Option v-for="item in originciLayerList" :value="item.codeId" :key="item.codeId">
                      {{ item.value }}
                    </Option>
                  </Select>
                  <Tooltip :content="$t('add_layer')" placement="top-start">
                    <Button size="small" @click="openLayerModal('layer')" class="btn-add-c" icon="md-add"></Button>
                  </Tooltip>
                </p>
                <p class="search-item">
                  <span class="filter-title">{{ $t('state') }}</span>
                  <Select multiple :max-tag-count="1" v-model="currentStatus" style="flex: 1;width:160px">
                    <Option v-for="item in statusList" :value="item.value" :key="item.value">
                      {{ item.value }}
                    </Option>
                  </Select>
                </p>
                <Button type="primary" @click="newInitGraph" style="vertical-align: top;">{{ $t('confirm') }}</Button>
                <Button @click="openDataPermissionManagement" style="vertical-align: top;float: right;">{{
                  $t('data_management')
                }}</Button>
              </div>
            </Col>
          </Row>
          <div class="graph-container" id="graph">
            <Spin fix v-if="spinShow">
              <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
            </Spin>
          </div>
        </Card>
      </div>
    </Col>
    <Col span="5" offset="0" class="func-wrapper" v-if="currentSelectData.id">
      <Card style="height: calc(100vh - 108px);overflow: auto;">
        <Row slot="title">
          <Col span="12">
            <p>{{ currentSelectData.displayName }}</p>
          </Col>
          <span class="header-buttons-container">
            <Tooltip :content="$t('new_ci_attribute')" placement="top-start">
              <Button size="small" @click="addNewAttrHandler" icon="md-add"></Button>
            </Tooltip>
            <span v-if="currentSelectData.type === 'GROUP'">
              <Tooltip :content="$t('move_up_layer')" placement="top-start">
                <Button size="small" @click="moveLayer(true)" icon="md-arrow-up"></Button>
              </Tooltip>
              <Tooltip :content="$t('move_down_layer')" placement="top-start">
                <Button size="small" @click="moveLayer(false)" icon="md-arrow-down"></Button>
              </Tooltip>
            </span>
            <Tooltip :content="$t('edit_name')" placement="top-start">
              <Button size="small" @click="editName" icon="md-build"></Button>
            </Tooltip>
            <Tooltip :content="$t('update_ci_attr_order')" placement="top-start">
              <Button size="small" @click="updateCIAttrOrder" icon="ios-list"></Button>
            </Tooltip>
          </span>
        </Row>
        <div v-if="currentSelectData.type === 'CI'">
          <draggable tag="ul" :list="currentCiTypeAttr" class="list-group" handle=".handle">
            <template v-for="(element, index) in currentCiTypeAttr">
              <div
                :key="element.name"
                style="padding:6px; border-bottom:1px solid #e8eaec;cursor:pointer"
                :class="element.isActive ? 'element-active' : ''"
                @click="openDrawer('CI', element, index)"
              >
                <span style="cursor: move;vertical-align: middle;">
                  <Icon type="md-reorder" class="handle" size="24" />
                </span>
                <span class="text">{{ element.name }} </span>

                <span v-if="element.source !== 'template'" style="vertical-align: middle;float:right">
                  <Button
                    size="small"
                    v-if="element.status === 'deleted'"
                    @click="restoreCIAttr($event, element)"
                    icon="ios-redo"
                  ></Button>
                  <Button size="small" v-else @click="deleteCIAttr($event, element)" icon="ios-trash"></Button>
                </span>
              </div>
            </template>
          </draggable>
        </div>
        <div v-if="currentSelectData.type === 'GROUP'">
          <template v-for="(element, index) in currentGroupAttr">
            <div
              :key="element.name"
              style="padding:6px; border-bottom:1px solid #e8eaec;cursor:pointer"
              @click="openDrawer('GROUP', element, index)"
            >
              <span style="vertical-align: middle;">
                <Icon type="md-reorder" class="handle" size="24" />
              </span>
              <span class="text">{{ element.name }} </span>

              <span style="vertical-align: middle;float:right">
                <Button
                  size="small"
                  v-if="element.status === 'deleted'"
                  @click="restoreCiTypes($event, element)"
                  icon="ios-redo"
                ></Button>
                <Button size="small" v-else @click="deleteCI($event, element)" icon="ios-trash"></Button>
              </span>
            </div>
          </template>
        </div>
      </Card>
    </Col>
    <Col span="5" offset="0" class="func-wrapper" v-if="currentSelectData.id === ''">
      <Card style="height: calc(100vh - 108px);">
        <Row slot="title">
          <p>{{ $t('input_area') }}</p>
        </Row>
        <p>{{ $t('architecture_diagram_operation_tips') }}</p>
      </Card>
    </Col>
    <!-- 编辑CI名称-开始 -->
    <Modal v-model="isEditCINameModalVisible" :title="$t('edit_ci_name')" @on-ok="editCIName" @on-cancel="() => {}">
      <Input v-model="currentSelectData.displayName" :placeholder="$t('input_placeholder')" />
    </Modal>
    <!-- 编辑CI名称-结束-->

    <!-- 编辑Group名称-开始 -->
    <Modal
      v-model="isEditLayerNameModalVisible"
      :title="$t('edit_layer_name')"
      @on-ok="editLayerName"
      @on-cancel="() => {}"
    >
      <Input v-model="currentSelectData.displayName" :placeholder="$t('input_placeholder')" />
    </Modal>
    <!-- 编辑Group名称-结束 -->

    <!-- 新增CI属性-开始 -->
    <Modal
      v-model="isAddNewAttrModalVisible"
      :title="$t('new_ci_attribute')"
      @on-visible-change="addAttrModalToggle"
      v-auto-height
    >
      <Form
        class="validation-form"
        :rules="ciAttrFormRuleValidate"
        ref="addNewAttrForm"
        :model="addNewAttrForm"
        label-position="right"
        :label-width="150"
      >
        <FormItem prop="propertyName" :label="$t('ci_attribute_id')">
          <Input v-model.trim="addNewAttrForm.propertyName" :placeholder="$t('db_citype_id_rule_placeholder')" />
        </FormItem>
        <FormItem :label="$t('ci_attribute_name')" prop="name">
          <Input v-model.trim="addNewAttrForm.name" :placeholder="$t('input_placeholder')" />
        </FormItem>
        <FormItem class="no-need-validation" :label="$t('description')" prop="description">
          <Input
            v-model.trim="addNewAttrForm.description"
            type="textarea"
            :rows="2"
            :autosize="true"
            :placeholder="$t('input_placeholder')"
          />
        </FormItem>
        <FormItem v-if="addNewAttrForm.inputType !== 'password'" :label="$t('search_filter_number')">
          <InputNumber :min="0" v-model.trim="addNewAttrForm.uiSearchOrder" :placeholder="$t('input_placeholder')" />
        </FormItem>
        <FormItem prop="inputType" :label="$t('data_type')">
          <Select
            v-model="addNewAttrForm.inputType"
            @on-change="onInputTypeChange($event, 'addNewAttrForm')"
            filterable
          >
            <Option v-for="(item, index) in allInputTypes" :value="item.code" :key="item.code + '' + index">{{
              item.code
            }}</Option>
          </Select>
        </FormItem>
        <FormItem
          v-if="['text', 'textArea', 'password'].includes(addNewAttrForm.inputType)"
          prop="regularExpressionRule"
          :label="$t('regular_rule')"
        >
          <Input v-model.trim="addNewAttrForm.regularExpressionRule" :placeholder="$t('input_placeholder')" />
        </FormItem>
        <FormItem prop="propertyType" :label="$t('real_type')">
          <Input v-model.trim="addNewAttrForm.propertyType" disabled></Input>
        </FormItem>
        <FormItem
          prop="length"
          :label="$t('length')"
          v-if="
            ['text', 'ref', 'extRef', 'textArea', 'number', 'password', 'multiText'].includes(addNewAttrForm.inputType)
          "
        >
          <InputNumber :min="1" v-model.trim="addNewAttrForm.length"></InputNumber>
        </FormItem>
        <FormItem
          prop="referenceId"
          v-if="['ref', 'multiRef'].includes(addNewAttrForm.inputType)"
          :label="$t('reference_select')"
        >
          <Select v-model="addNewAttrForm.referenceId" filterable>
            <Option v-for="item in allCiTypesWithAttr" :value="item.ciTypeId" :key="item.ciTypeId">{{
              item.name
            }}</Option>
          </Select>
        </FormItem>
        <!--外部引用选择-->
        <FormItem prop="extRefEntity" v-if="['extRef'].includes(addNewAttrForm.inputType)" :label="$t('cmdb_extRef')">
          <Select v-model="addNewAttrForm.extRefEntity" filterable>
            <Option v-for="item in extRefOptions" :value="item.value" :key="item.value">{{ item.label }}</Option>
          </Select>
        </FormItem>
        <FormItem
          prop="referenceName"
          v-if="['ref', 'multiRef'].includes(addNewAttrForm.inputType)"
          :label="$t('reference_name')"
        >
          <Input v-model.trim="addNewAttrForm.referenceName" :placeholder="$t('input_placeholder')" />
        </FormItem>
        <FormItem
          prop="referenceType"
          v-if="['ref', 'multiRef'].includes(addNewAttrForm.inputType)"
          :label="$t('reference_type')"
        >
          <Select v-model="addNewAttrForm.referenceType" filterable>
            <Option v-for="item in allReferenceTypes" :value="item.codeId" :key="item.codeId">{{ item.value }}</Option>
          </Select>
        </FormItem>
        <FormItem
          prop="selectList"
          v-if="['select', 'multiSelect'].includes(addNewAttrForm.inputType)"
          :label="$t('enum_config')"
        >
          <Select v-model="addNewAttrForm.selectList" filterable ref="addSelectOption">
            <Button type="success" style="width:100%" @click="showCreatCat" size="small">
              <Icon type="ios-add" size="24"></Icon>
            </Button>
            <Option v-for="item in catOptions" :value="item.catId" :key="item.catId">{{ item.catName }}</Option>
          </Select>
        </FormItem>
        <FormItem
          class="no-need-validation"
          v-if="['ref', 'multiRef'].includes(addNewAttrForm.inputType) && addNewAttrForm.referenceId !== ''"
          :label="$t('update_state')"
        >
          <Button @click="configState('refUpdateStateValidate', 'add')">{{ $t('configuration') }}</Button>
        </FormItem>
        <FormItem
          class="no-need-validation"
          v-if="['ref', 'multiRef'].includes(addNewAttrForm.inputType) && addNewAttrForm.referenceId !== ''"
          :label="$t('confirm_state')"
        >
          <Button @click="configState('refConfirmStateValidate', 'add')">{{ $t('configuration') }}</Button>
        </FormItem>
        <FormItem prop="resetOnEdit" :label="$t('is_refreshable')">
          <RadioGroup v-model="addNewAttrForm.resetOnEdit">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem prop="displayByDefault" :label="$t('is_displayed')">
          <RadioGroup v-model="addNewAttrForm.displayByDefault">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem
          prop="permissionUsage"
          v-if="['select', 'multiSelect', 'ref', 'extRef', 'multiRef'].includes(addNewAttrForm.inputType)"
          :label="$t('is_access_controlled')"
        >
          <RadioGroup v-model="addNewAttrForm.permissionUsage">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem prop="editGroupControl" :label="$t('edit_group_control')">
          <RadioGroup v-model="addNewAttrForm.editGroupControl">
            <Radio :disabled="addNewAttrForm.status === 'deleted'" label="yes">Yes</Radio>
            <Radio :disabled="addNewAttrForm.status === 'deleted'" label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem
          class="no-need-validation"
          v-if="addNewAttrForm.editGroupControl !== 'no'"
          :label="$t('edit_group_value')"
        >
          <Button @click="configEditGroup('add', addNewAttrForm)">{{ $t('configuration') }}</Button>
        </FormItem>
        <FormItem prop="nullable" :label="$t('is_nullable')">
          <RadioGroup v-model="addNewAttrForm.nullable">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem prop="editable" :label="$t('is_editable')">
          <RadioGroup v-model="addNewAttrForm.editable">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem prop="uiNullable" :label="$t('is_uiNullable')">
          <RadioGroup v-model="addNewAttrForm.uiNullable">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem prop="uniqueConstraint" :label="$t('is_unique')">
          <RadioGroup v-model="addNewAttrForm.uniqueConstraint">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem
          v-if="['text', 'password'].includes(addNewAttrForm.inputType)"
          prop="sensitive"
          :label="$t('db_is_independent_permission_control')"
        >
          <RadioGroup v-model="addNewAttrForm.sensitive">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem prop="confirmNullable" :label="$t('confirmed_empty')">
          <RadioGroup v-model="addNewAttrForm.confirmNullable">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem prop="autofillable" v-if="addNewAttrForm.inputType !== 'password'" :label="$t('is_auto')">
          <RadioGroup v-model="addNewAttrForm.autofillable">
            <Radio label="yes">Yes</Radio>
            <Radio label="no">No</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem
          prop="autoFillType"
          v-if="addNewAttrForm.autofillable === 'yes' && addNewAttrForm.inputType !== 'password'"
          :label="$t('auto_fill_type')"
        >
          <Select v-model="addNewAttrForm.autoFillType" filterable>
            <Option v-for="item in autoFillTypes" :value="item.value" :key="item.value">{{ item.label }}</Option>
          </Select>
        </FormItem>
        <FormItem
          prop="ciGroup"
          v-if="addNewAttrForm.autofillable === 'yes' && addNewAttrForm.inputType !== 'password'"
          :label="$t('auto_fill_rule')"
        >
          <AutoFill
            ref="autoFillRef"
            :allCiTypes="allCiTypesWithAttr"
            :rootCiTypeId="currentSelectData.id"
            :specialDelimiters="specialDelimiters"
            v-model="addNewAttrForm.autoFillRule"
          ></AutoFill>
        </FormItem>
        <FormItem
          class="no-need-validation"
          v-if="['ref', 'multiRef'].includes(addNewAttrForm.inputType) && addNewAttrForm.referenceId !== ''"
          :label="$t('filter_rule')"
        >
          <FilterRule
            v-model="addNewAttrForm.referenceFilter"
            :allCiTypes="allCiTypesWithAttr"
            :rootCiTypeId="currentSelectData.id"
            :leftRootCi="allCiTypesFormatByCiTypeId[addNewAttrForm.referenceId].ciTypeId"
            :rightRootCi="currentSelectData.id"
            :banRootCiDelete="true"
          ></FilterRule>
        </FormItem>
        <!-- <FormItem>
          <Button class="fixed" type="primary" small @click="addNewAttr" :loading="buttonLoading.addNewAttr" style="float: right">{{
            $t('save')
          }}</Button>
        </FormItem> -->
      </Form>
      <div slot="footer">
        <Button type="primary" small @click="addNewAttr" :loading="buttonLoading.addNewAttr">{{ $t('save') }}</Button>
      </div>
    </Modal>
    <!-- 新增CI属性-结束 -->

    <!-- 新增CI-开始 -->
    <Modal
      v-model="isAddNewCITypeModalVisible"
      :title="$t('new_ci_type')"
      @on-visible-change="addCiTypeModalToggle"
      footer-hide
    >
      <Form
        ref="addNewCITypeForm"
        class="add_new_ci_type_form"
        :rules="ruleValidate"
        :model="addNewCITypeForm"
        label-position="left"
        :label-width="100"
      >
        <FormItem :label="$t('ci_type_id')" prop="ciTypeId">
          <Input v-model.trim="addNewCITypeForm.ciTypeId" :placeholder="$t('db_citype_id_rule_placeholder')"></Input>
        </FormItem>
        <FormItem :label="$t('table_name')" prop="name">
          <Input v-model.trim="addNewCITypeForm.name" :placeholder="$t('input_placeholder')"></Input>
        </FormItem>
        <FormItem :label="$t('zoom_level')" prop="ciLayer">
          <Select :max-tag-count="3" v-model="addNewCITypeForm.ciLayer" filterable>
            <Option v-for="item in originciLayerList" :value="item.codeId" :key="item.codeId">{{ item.value }}</Option>
          </Select>
        </FormItem>
        <FormItem :label="$t('refrence_layer')">
          <Select disabled v-model="addNewCITypeForm.ciGroup" filterable>
            <Option v-for="group in originciGroupList" :value="group.codeId" :key="group.codeId">{{
              group.value
            }}</Option>
          </Select>
        </FormItem>
        <FormItem :label="$t('ci_template')">
          <Select v-model="addNewCITypeForm.ciTemplate" filterable>
            <Option v-for="layer in ciTemplateOptions" :value="layer.id" :key="layer.id">{{
              layer.description
            }}</Option>
          </Select>
        </FormItem>
        <FormItem class="no-need-validation" :label="$t('description')" prop="description">
          <Input v-model.trim="addNewCITypeForm.description"></Input>
        </FormItem>
        <FormItem prop="imageFileId" :label="$t('icon')">
          <Upload :before-upload="handleUpload" action="">
            <Button class="btn-upload">
              <img src="@/styles/icon/UploadOutlined.png" class="upload-icon" />
              {{ $t('upload_icon_btn') }}
            </Button>
            <!-- <Button icon="ios-cloud-upload-outline">{{ $t('upload_icon_btn') }}</Button> -->
          </Upload>
          <div v-if="this.addNewCITypeForm.fileName">{{ this.addNewCITypeForm.fileName }}</div>
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
    <!-- 新增CI-结束 -->

    <!-- 新增layer-开始 -->
    <Modal v-model="isAddNewLayerModalVisible" :title="$t('new')" @on-visible-change="addLayerModalToggle">
      <Form class="validation-form" ref="newLayerForm" :model="newLayer" label-position="left" :label-width="100">
        <FormItem label="Key" prop="addNewLayerCode">
          <Input v-model="newLayer.addNewLayerCode" />
        </FormItem>
        <FormItem label="Value" prop="addNewLayerValue">
          <Input v-model="newLayer.addNewLayerValue" />
        </FormItem>
        <FormItem class="no-need-validation" :label="$t('description')" prop="addNewLayerDescription">
          <Input v-model="newLayer.addNewLayerDescription" />
        </FormItem>
      </Form>
      <div slot="footer">
        <Button type="primary" @click="addNewLayer('newLayerForm')" :loading="buttonLoading.newLayer">{{
          $t('submit')
        }}</Button>
      </div>
    </Modal>
    <!-- 新增layer-结束 -->
    <!-- 操作区-开始 -->
    <div
      class="file-content"
      :style="{
        display: isOpenDrawer ? 'inherit' : 'none'
      }"
      type="primary"
    >
      <div style="margin-top: 8px;padding: 6px;width: 100%;">
        <template v-if="currentSelectData.type === 'CI'">
          <div class="attr-detail">
            <Form class="validation-form" ref="ciAttrForm" label-position="right" :label-width="110">
              <FormItem prop="propertyName" :label="$t('ci_attribute_id')">
                <Input v-model="editCiAttr.propertyName" disabled></Input>
              </FormItem>
              <FormItem prop="name" :label="$t('ci_attribute_name')">
                <Input
                  v-model="editCiAttr.name"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                ></Input>
              </FormItem>
              <FormItem class="no-need-validation" prop="description" :label="$t('description')">
                <Input
                  v-model="editCiAttr.description"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                  type="textarea"
                  :rows="2"
                  :autosize="true"
                />
              </FormItem>
              <FormItem
                v-if="editCiAttr.inputType !== 'password'"
                :label="$t('search_filter_number')"
                prop="uiSearchOrder"
              >
                <InputNumber
                  :min="0"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                  v-model="editCiAttr.uiSearchOrder"
                ></InputNumber>
              </FormItem>
              <FormItem prop="inputType" :label="$t('data_type')">
                <Select
                  filterable
                  v-model="editCiAttr.inputType"
                  @on-change="onInputTypeChange($event, 'editCiAttr')"
                  :disabled="
                    editCiAttr.propertyName === 'state' ||
                      editCiAttr.status !== 'notCreated' ||
                      editCiAttr.customizable !== 'yes'
                  "
                >
                  <Option v-for="(item, index) in allInputTypes" :value="item.code" :key="item.code + '' + index">{{
                    item.code
                  }}</Option>
                </Select>
              </FormItem>
              <FormItem
                v-if="['text', 'textArea', 'password'].includes(editCiAttr.inputType)"
                prop="regularExpressionRule"
                :label="$t('regular_rule')"
              >
                <Input v-model="editCiAttr.regularExpressionRule" :disabled="editCiAttr.customizable !== 'yes'"></Input>
              </FormItem>
              <FormItem :label="$t('real_type')">
                <Input v-model="editCiAttr.propertyType" disabled></Input>
              </FormItem>
              <FormItem
                prop="length"
                :label="$t('length')"
                v-if="
                  ['text', 'ref', 'extRef', 'textArea', 'number', 'password', 'multiText'].includes(
                    editCiAttr.inputType
                  )
                "
              >
                <InputNumber
                  :min="1"
                  :disabled="editCiAttr.customizable !== 'yes'"
                  v-model="editCiAttr.length"
                ></InputNumber>
              </FormItem>
              <FormItem
                prop="referenceId"
                v-if="['ref', 'multiRef'].includes(editCiAttr.inputType)"
                :label="$t('reference_select')"
              >
                <Select
                  v-model="editCiAttr.referenceId"
                  :disabled="
                    !['deleted', 'notCreated'].includes(editCiAttr.status) || editCiAttr.customizable !== 'yes'
                  "
                  filterable
                >
                  <Option v-for="item in allCiTypesWithAttr" :value="item.ciTypeId" :key="item.ciTypeId">{{
                    item.name
                  }}</Option>
                </Select>
              </FormItem>
              <!--外部引用选择-->
              <FormItem prop="extRefEntity" v-if="['extRef'].includes(editCiAttr.inputType)" :label="$t('cmdb_extRef')">
                <Select
                  v-model="editCiAttr.extRefEntity"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                  filterable
                >
                  <Option v-for="item in extRefOptions" :value="item.value" :key="item.value">{{ item.label }}</Option>
                </Select>
              </FormItem>
              <FormItem
                prop="referenceName"
                v-if="['ref', 'multiRef'].includes(editCiAttr.inputType)"
                :label="$t('reference_name')"
              >
                <Input
                  v-model="editCiAttr.referenceName"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                ></Input>
              </FormItem>
              <FormItem
                prop="referenceType"
                v-if="['ref', 'multiRef'].includes(editCiAttr.inputType)"
                :label="$t('reference_type')"
              >
                <Select
                  v-model="editCiAttr.referenceType"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                  filterable
                >
                  <Option v-for="item in allReferenceTypes" :value="item.codeId" :key="item.codeId">{{
                    item.value
                  }}</Option>
                </Select>
              </FormItem>
              <FormItem
                class="no-need-validation"
                v-if="['ref', 'multiRef'].includes(editCiAttr.inputType) && editCiAttr.referenceId !== ''"
                :label="$t('update_state')"
              >
                <Button
                  @click="configState('refUpdateStateValidate', 'edit')"
                  :disabled="editCiAttr.customizable !== 'yes'"
                  >{{ $t('configuration') }}</Button
                >
              </FormItem>
              <FormItem
                class="no-need-validation"
                v-if="['ref', 'multiRef'].includes(editCiAttr.inputType) && editCiAttr.referenceId !== ''"
                :label="$t('confirm_state')"
              >
                <Button
                  @click="configState('refConfirmStateValidate', 'edit')"
                  :disabled="editCiAttr.customizable !== 'yes'"
                  >{{ $t('configuration') }}</Button
                >
              </FormItem>
              <FormItem
                prop="selectList"
                v-if="['select', 'multiSelect'].includes(editCiAttr.inputType)"
                :label="$t('enum_config')"
              >
                <Select
                  v-model="editCiAttr.selectList"
                  filterable
                  ref="addSelectOption"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                >
                  <Button type="success" style="width:100%" @click="showCreatCat" size="small">
                    <Icon type="ios-add" size="24"></Icon>
                  </Button>
                  <Option v-for="item in catOptions" :value="item.catId" :key="item.catId">{{ item.catName }}</Option>
                </Select>
              </FormItem>
              <FormItem prop="editGroupControl" :label="$t('edit_group_control')">
                <RadioGroup v-model="editCiAttr.editGroupControl">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem
                class="no-need-validation"
                v-if="editCiAttr.editGroupControl !== 'no'"
                :label="$t('edit_group_value')"
              >
                <Button @click="configEditGroup('edit', editCiAttr)">{{ $t('configuration') }}</Button>
              </FormItem>
              <FormItem prop="resetOnEdit" :label="$t('is_refreshable')">
                <RadioGroup v-model="editCiAttr.resetOnEdit">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem prop="displayByDefault" :label="$t('is_displayed')">
                <RadioGroup v-model="editCiAttr.displayByDefault">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem
                prop="permissionUsage"
                v-if="['select', 'ref', 'extRef', 'multiSelect', 'multiRef'].includes(editCiAttr.inputType)"
                :label="$t('is_access_controlled')"
              >
                <RadioGroup v-model="editCiAttr.permissionUsage">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem prop="nullable" :label="$t('is_nullable')">
                <RadioGroup v-model="editCiAttr.nullable">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem prop="editable" :label="$t('is_editable')">
                <RadioGroup v-model="editCiAttr.editable">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem prop="uiNullable" :label="$t('is_uiNullable')">
                <RadioGroup v-model="editCiAttr.uiNullable">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem prop="uniqueConstraint" :label="$t('is_unique')">
                <RadioGroup v-model="editCiAttr.uniqueConstraint">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem
                v-if="['text', 'password'].includes(editCiAttr.inputType)"
                prop="sensitive"
                :label="$t('db_is_independent_permission_control')"
              >
                <RadioGroup v-model="editCiAttr.sensitive">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <FormItem prop="confirmNullable" :label="$t('confirmed_empty')">
                <RadioGroup v-model="editCiAttr.confirmNullable">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <!--自动填充-->
              <FormItem prop="autofillable" v-if="editCiAttr.inputType !== 'password'" :label="$t('is_auto')">
                <RadioGroup v-model="editCiAttr.autofillable">
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="yes"
                    >Yes</Radio
                  >
                  <Radio :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'" label="no"
                    >No</Radio
                  >
                </RadioGroup>
              </FormItem>
              <!--填充类型-->
              <FormItem
                prop="autoFillType"
                v-if="editCiAttr.autofillable === 'yes' && editCiAttr.inputType !== 'password'"
                :label="$t('auto_fill_type')"
              >
                <Select
                  filterable
                  v-model="editCiAttr.autoFillType"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                >
                  <Option v-for="item in autoFillTypes" :value="item.value" :key="item.value">{{ item.label }}</Option>
                </Select>
              </FormItem>
              <!--填充规则-->
              <FormItem
                prop="autoFillRule"
                v-if="editCiAttr.autofillable === 'yes' && editCiAttr.inputType !== 'password'"
                :label="$t('auto_fill_rule')"
              >
                <AutoFill
                  ref="autoFillRef"
                  :allCiTypes="allCiTypesWithAttr"
                  :rootCiTypeId="editCiAttr.ciTypeId"
                  :specialDelimiters="specialDelimiters"
                  v-model="editCiAttr.autoFillRule"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                ></AutoFill>
              </FormItem>
              <!-- 过滤规则 -->
              <FormItem
                class="no-need-validation"
                v-if="['ref', 'multiRef'].includes(editCiAttr.inputType) && editCiAttr.referenceId !== ''"
                :label="$t('filter_rule')"
              >
                <FilterRule
                  v-model="editCiAttr.referenceFilter"
                  :allCiTypes="allCiTypesWithAttr"
                  :rootCiTypeId="editCiAttr.ciTypeId"
                  :leftRootCi="allCiTypesFormatByCiTypeId[editCiAttr.referenceId].ciTypeId"
                  :rightRootCi="currentSelectData.id"
                  :banRootCiDelete="true"
                  :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
                ></FilterRule>
              </FormItem>
            </Form>
          </div>
          <div style="margin-right: 30px;">
            <Button
              type="primary"
              @click="applyAttr(editCiAttr.ciTypeAttrId, editCiAttr)"
              :loading="buttonLoading.applyAttr"
              style="float: right"
              size="small"
              :disabled="editCiAttr.status === 'deleted' || editCiAttr.customizable !== 'yes'"
              >{{ $t('submit') }}</Button
            >
            <Button
              type="primary"
              size="small"
              @click="saveAttr(editCiAttr.ciTypeAttrId, editCiAttr)"
              :loading="buttonLoading.saveAttr"
              style="float: right; margin-right: 20px"
              :disabled="editCiAttr.status !== 'notCreated' || editCiAttr.customizable !== 'yes'"
              >{{ $t('save_draft') }}</Button
            >
            <Button type="primary" size="small" @click="closeDrawer" style="float: right; margin-right: 20px">{{
              $t('cancel')
            }}</Button>
          </div>
        </template>
        <template v-if="currentSelectData.type === 'GROUP'">
          <div class="attr-detail">
            <Form class="validation-form" :model="editGroupAttr" label-position="left" :label-width="100">
              <FormItem :label="$t('ci_type_id')" prop="ciTypeId">
                <Input v-model="editGroupAttr.ciTypeId" disabled></Input>
              </FormItem>
              <FormItem :label="$t('zoom_level')" prop="ciLayer">
                <Select
                  :max-tag-count="3"
                  v-model="editGroupAttr.ciLayer"
                  filterable
                  :disabled="editGroupAttr.status === 'deleted'"
                >
                  <Option v-for="item in originciLayerList" :value="item.codeId" :key="item.codeId">{{
                    item.value
                  }}</Option>
                </Select>
              </FormItem>
              <FormItem :label="$t('refrence_layer')">
                <Select v-model="editGroupAttr.ciGroup" :disabled="editGroupAttr.status === 'deleted'" filterable>
                  <Option v-for="group in originciGroupList" :value="group.codeId" :key="group.codeId">{{
                    group.value
                  }}</Option>
                </Select>
              </FormItem>
              <FormItem :label="$t('ci_template')">
                <Select v-model="editGroupAttr.ciTemplate" :disabled="editGroupAttr.status === 'deleted'" filterable>
                  <Option v-for="layer in ciTemplateOptions" :value="layer.id" :key="layer.id">{{
                    layer.description
                  }}</Option>
                </Select>
              </FormItem>
              <FormItem class="no-need-validation" :label="$t('description')" prop="description">
                <Input v-model="editGroupAttr.description" :disabled="editGroupAttr.status === 'deleted'"></Input>
              </FormItem>
              <FormItem :label="$t('icon')">
                <img
                  v-if="editGroupAttr.imageFile"
                  :src="`/wecmdb/fonts/${editGroupAttr.imageFile}`"
                  height="58"
                  width="58"
                />
                <Upload :before-upload="handleUploadEdit" action="" :disabled="editGroupAttr.status === 'deleted'">
                  <Button class="btn-upload">
                    <img src="@/styles/icon/UploadOutlined.png" class="upload-icon" />
                    {{ $t('upload_icon_btn') }}
                  </Button>
                  <!-- <Button icon="ios-cloud-upload-outline">{{ $t('upload_icon_btn') }}</Button> -->
                </Upload>
                <div v-if="this.editGroupAttr.fileName">{{ this.editGroupAttr.fileName }}</div>
              </FormItem>
            </Form>
          </div>
          <div style="margin-right: 30px;">
            <Button
              type="primary"
              size="small"
              @click="submitCiType(editGroupAttr)"
              :loading="buttonLoading.submitCiType"
              style="float: right"
              :disabled="editGroupAttr.status === 'deleted'"
              >{{ $t('submit') }}</Button
            >
            <Button
              type="primary"
              size="small"
              style="float: right;margin-right: 10px"
              @click="saveCiType(editGroupAttr)"
              :loading="buttonLoading.saveCiType"
              :disabled="editGroupAttr.status !== 'notCreated'"
              >{{ $t('save_draft') }}</Button
            >
            <Button type="primary" size="small" @click="closeDrawer" style="float: right; margin-right: 20px">{{
              $t('cancel')
            }}</Button>
          </div>
        </template>
      </div>
    </div>
    <!-- 操作区-结束 -->

    <!-- ref/multiref 配置 -->
    <Modal v-model="stateConfigModel" :title="$t('configuration')" @on-ok="confirmStateData" width="700">
      <AttrKeyValueConfig ref="attrKeyValueConfig" :stateConfig="stateConfig"></AttrKeyValueConfig>
    </Modal>

    <!-- selectList 配置 -->
    <Modal v-model="selectListConfigModel" :title="$t('configuration')" @on-ok="confirmSelectListData" width="700">
      <AttrKeyConfig ref="selectListConfig" :selectListConfig="selectListConfig"></AttrKeyConfig>
    </Modal>

    <!-- editGroupControl 配置 -->
    <Modal
      v-model="editGroupControlModel.isShow"
      :title="$t('configuration')"
      @on-ok="confirmEditGroupValues"
      width="700"
    >
      <EditGroupControlConfig ref="editGroupControlConfig"></EditGroupControlConfig>
    </Modal>
    <!-- 数据权限 配置 -->
    <Modal
      v-model="showDataPermissionModal"
      :title="$t('data_management')"
      footer-hide
      @on-ok="confirmSelectListData"
      :fullscreen="isfullscreen"
      width="1200"
    >
      <!-- <div slot="header" class="custom-modal-header">
        <Icon size="16" v-if="isfullscreen" @click="isfullscreen = !isfullscreen" type="ios-contract" />
        <Icon size="16" v-else @click="isfullscreen = !isfullscreen" type="ios-expand" />
      </div> -->
      <DataAuthorization ref="DataAuthorization" @hideModal="showDataPermissionModal = false"></DataAuthorization>
    </Modal>

    <!-- 新增cat 配置 -->
    <Modal
      v-model="catCreateModal.showCatCreatModal"
      :title="$t('new')"
      @on-ok="createCat"
      @on-cancel="catCreateModal.showCatCreatModal = false"
      width="600"
    >
      <Form label-position="left" :label-width="100">
        <FormItem label="ID">
          <Input v-model="catCreateModal.params.catId"></Input>
        </FormItem>
        <FormItem :label="$t('table_name')">
          <Input v-model="catCreateModal.params.catName"></Input>
        </FormItem>
        <FormItem :label="$t('description')">
          <Input v-model="catCreateModal.params.description"></Input>
        </FormItem>
      </Form>
    </Modal>
  </Row>
</template>

<script>
import * as d3 from 'd3-selection'
import draggable from 'vuedraggable'
// eslint-disable-next-line
import * as d3Graphviz from 'd3-graphviz'
import { addEvent } from '../util/event.js'
import DataAuthorization from './data-authorization'
import {
  createCat,
  getAllCITypesByLayerWithAttr,
  getGroupByOptions,
  getCiByOptions,
  createLayer,
  getStateMachine,
  deleteCITypeByID,
  deleteAttr,
  updateCIAttrOrder,
  updateCIType,
  applyCiTypes,
  restoreCIAttr,
  restoreCiTypes,
  createNewCIType,
  updateLayer,
  createNewCIAttr,
  updateCIAttr,
  getSystemEnumCodesBy,
  applyCIAttr,
  getEnumCodesByCategoryId,
  createEnumCode,
  getCiTemplate,
  getAllEnumCategories,
  moveLayer,
  getExtRefOptions
} from '@/api/server'
import AutoFill from '../components/auto-fill.js'
import FilterRule from '../components/filter-rule/index.js'
import { CI_LAYER, CI_GROUP, INPUT_TYPE_CONFIG } from '@/const/init-params.js'
import AttrKeyValueConfig from '@/pages/components/attr-key-value-config'
import AttrKeyConfig from '@/pages/components/attr-key-config'
import EditGroupControlConfig from '@/pages/components/edit-group-control-config'
import autoHeight from '@/directive/auto-height'

export default {
  directives: {
    autoHeight
  },
  components: {
    AutoFill,
    FilterRule,
    draggable,
    AttrKeyValueConfig,
    EditGroupControlConfig,
    AttrKeyConfig,
    DataAuthorization
  },
  data () {
    return {
      catCreateModal: {
        showCatCreatModal: false,
        params: {
          catId: '',
          catName: '',
          description: ''
        }
      },
      currentciLayer: [],
      ciLayerList: [],
      currentciGroup: [],
      ciGroupList: [],
      layers: [],
      graph: {},
      isLayerSelected: false,
      nodeName: '',
      g: null,
      n: null,
      statusList: [
        { label: 'notCreated', value: 'notCreated' },
        { label: 'created', value: 'created' },
        { label: 'deleted', value: 'deleted' },
        { label: 'dirty', value: 'dirty' }
      ],
      currentStatus: ['notCreated', 'created', 'dirty'],
      newLayer: {
        addNewLayerCode: '',
        addNewLayerValue: '',
        addNewLayerDescription: ''
      },
      levelOrLayer: '',
      isAddNewLayerModalVisible: false,
      isEditLayerNameModalVisible: false,
      isAddNewCITypeModalVisible: false,
      isEditCINameModalVisible: false,
      isAddNewAttrModalVisible: false,
      updatedLayerNameValue: {},
      updatedCINameValue: {}, // 标记删除
      currentSelectLayerChildren: [],
      autoFillTypes: [
        { label: 'suggest', value: 'suggest' },
        { label: 'forced', value: 'forced' }
      ],
      addNewCITypeForm: {
        name: '',
        ciTypeId: '',
        ciLayer: null,
        ciGroup: '',
        description: '',
        imageFileId: undefined,
        fileName: '',
        imageFile: '',
        ciTemplate: '',
        selectList: ''
      },
      ciTemplateOptions: [],
      ruleValidate: {
        ciTypeId: [
          {
            type: 'string',
            required: true,
            trigger: 'blur',
            pattern: /^[a-z][a-z0-9_]{0,48}[a-z0-9_]$/,
            message: `【${this.$t('db_citype_id_rule_placeholder')}】`
          }
        ],
        name: [{ type: 'string', required: true, trigger: 'blur', message: `${this.$t('table_name_is_require')}` }],
        // ciLayer: [
        //   { required: true, type: 'number', trigger: 'change', message: `${this.$t('zoom_level_is_require')}` }
        // ],
        ciGroup: [{ required: true, trigger: 'change', message: `${this.$t('refrence_layer')}` }]
        // imageFileId: [{ required: true, message: `${this.$t('icon_is_require')}` }]
      },
      ciAttrFormRuleValidate: {
        // propertyName: [{ type: 'string', required: true, trigger: 'blur', message: `${this.$t('table_name_is_require')}` }],
        // name,
        // description,
        // uiSearchOrder,
        // inputType,
        // regularExpressionRule,
        // propertyType,
        // length
      },
      addNewAttrForm: {
        inputType: 'text',
        propertyType: 'varchar',
        length: 255,
        referenceId: '',
        uiSearchOrder: 0,
        editGroupControl: 'yes',
        editGroupValues: '[]',
        permissionUsage: 'no',
        resetOnEdit: 'no',
        displayByDefault: 'no',
        nullable: 'no',
        autofillable: 'no',
        editable: 'yes',
        uiNullable: 'yes',
        autoFillType: 'suggest',
        uniqueConstraint: 'no',
        confirmNullable: 'yes',
        extRefEntity: '',
        sensitive: 'no'
      },
      allCiTypesWithAttr: [],
      allCiTypesFormatByCiTypeId: {},
      extRefOptions: [],
      specialDelimiters: [
        { code: '&', value: '&' },
        { code: '=', value: '=' }
      ],
      allInputTypes: INPUT_TYPE_CONFIG,
      allReferenceTypes: [],
      buttonLoading: {
        newLayer: false,
        upLayer: false,
        downLayer: false,
        revertCI: {},
        saveCiType: false,
        submitCiType: false,
        addNewCIType: false,
        addNewAttrHandler: false,
        moveUpAttr: {},
        moveDownAttr: {},
        revertCIAttr: {},
        applyAttr: false,
        saveAttr: false,
        addNewAttr: false
      },
      isHandleNodeClick: false,
      headers: {},
      spinShow: false,

      originciLayerList: [],
      originciGroupList: [],
      originCITypesByLayerWithAttr: [],
      currentCiTypeAttr: [], // 当前CI属性
      oriCurrentCiTypeAttr: [], // 缓存ci attr信息，解决排序后未保存渲染selectList问题
      currentGroupAttr: [], // 当前GROUP属性
      currentSelectData: {
        // selected group or ci
        type: '',
        id: '',
        displayName: '' // 对应操作区标题
      },
      isOpenDrawer: false,
      editCiAttr: {}, // 当前编辑CI数据
      editGroupAttr: {}, // 当前编辑Group数据

      stateConfig: {
        // 更新、确认状态数据源
        optionType: '', // 编辑为新增or编辑
        stateTag: '', // 标记数据源
        originData: [],
        keyOption: [],
        valueOption: []
      },
      stateConfigModel: false,

      selectListConfig: {
        optionType: '', // 编辑为新增or编辑
        originData: []
      },
      selectListConfigModel: false,
      catOptions: [],
      showDataPermissionModal: false,
      editGroupControlModel: {
        isShow: false,
        attrAndSelect: [],
        type: ''
      },
      isfullscreen: true
    }
  },
  methods: {
    async moveLayer (tag) {
      const params = {
        codeId: this.currentSelectData.id,
        targetIndex: 0,
        up: tag
      }
      const { statusCode } = await moveLayer(params)
      if (statusCode === 'OK') {
        await this.getInitGraphData()
        this.getGroupByOptions()
        // this.getCatOptions()
      }
    },
    showCreatCat () {
      this.$refs.addSelectOption.visible = false
      this.catCreateModal.showCatCreatModal = true
    },
    async createCat () {
      const { statusCode } = await createCat(this.catCreateModal.params)
      if (statusCode === 'OK') {
        this.catCreateModal.params = {
          catId: '',
          catName: '',
          description: ''
        }
        this.getCatOptions()
      }
    },
    openDataPermissionManagement () {
      this.$refs.DataAuthorization.initData()
      this.showDataPermissionModal = true
    },
    async getCatOptions () {
      this.catOptions = []
      const { statusCode, data } = await getAllEnumCategories()
      if (statusCode === 'OK') {
        this.catOptions = data.contents
      }
    },
    configSelectList (optionType) {
      this.selectListConfig.optionType = optionType
      let info = optionType === 'add' ? this.addNewAttrForm['selectList'] : this.editCiAttr['selectList']
      if (info) {
        const infoJson = JSON.parse(info)
        this.selectListConfig.originData = infoJson.map(item => {
          return {
            key: item
          }
        })
      } else {
        this.selectListConfig.originData = [{ key: '' }]
      }
      this.$refs.selectListConfig.initData()
      this.selectListConfigModel = true
    },
    confirmSelectListData () {
      const selectRes = this.$refs.selectListConfig.selectList
      const finalRes = selectRes.filter(it => it.key).map(item => item.key)
      if (this.selectListConfig.optionType === 'add') {
        this.addNewAttrForm['selectList'] = JSON.stringify(finalRes)
      } else {
        this.editCiAttr['selectList'] = JSON.stringify(finalRes)
      }
    },
    configEditGroup (optionType, attr) {
      const filterAttr = this.currentCiTypeAttr.filter(item => {
        if (['select', 'multiSelect'].includes(item.inputType) && item.selectList !== '') {
          if (item.propertyName !== attr.propertyName) {
            return item
          }
        }
      })
      const attrAndSelect = filterAttr.map(item => {
        return {
          label: item.propertyName,
          selectList: item.selectList
        }
      })
      const editGroupValues =
        optionType === 'add'
          ? JSON.parse(this.addNewAttrForm.editGroupValues || '[]')
          : JSON.parse(this.editCiAttr.editGroupValues || '[]')
      this.editGroupControlModel.type = optionType
      this.editGroupControlModel.attrAndSelect = attrAndSelect
      this.editGroupControlModel.isShow = true
      this.$refs.editGroupControlConfig.initData(attrAndSelect, editGroupValues)
    },
    confirmEditGroupValues () {
      const res = this.$refs.editGroupControlConfig.stateSelect
      const finalRes = res
        .filter(it => it.key && it.value.length > 0)
        .map(item => {
          return { key: item.key, value: item.value }
        })
      if (this.editGroupControlModel.type === 'add') {
        this.addNewAttrForm.editGroupValues = JSON.stringify(finalRes)
      } else {
        this.editCiAttr.editGroupValues = JSON.stringify(finalRes)
      }
      this.$refs.editGroupControlConfig.clearAll()
    },
    async configState (tag, optionType) {
      this.stateConfig.stateTag = tag
      this.stateConfig.optionType = optionType
      const info = optionType === 'add' ? this.addNewAttrForm[tag] : this.editCiAttr[tag]
      if (optionType === 'add') {
        await this.selectRef(this.addNewAttrForm.referenceId)
      } else {
        await this.selectRef(this.editCiAttr.referenceId)
      }
      if (info) {
        const infoJson = JSON.parse(info)
        this.stateConfig.originData = infoJson.map(item => {
          return {
            key: Object.keys(item)[0],
            value: Object.values(item)[0]
          }
        })
      } else {
        this.stateConfig.originData = [{ key: '', value: '' }]
      }
      this.$refs.attrKeyValueConfig.initData()
      this.stateConfigModel = true
    },
    confirmStateData () {
      const stateRes = this.$refs.attrKeyValueConfig.stateSelect
      const finalRes = stateRes
        .filter(it => it.key && it.value)
        .map(item => {
          return { [item.key]: item.value }
        })
      if (this.stateConfig.optionType === 'add') {
        this.addNewAttrForm[this.stateConfig.stateTag] = JSON.stringify(finalRes)
      } else {
        this.editCiAttr[this.stateConfig.stateTag] = JSON.stringify(finalRes)
      }
    },
    async selectRef (val) {
      let stateMachineSet = new Set()
      this.allCiTypesWithAttr.forEach(item => {
        if (item.ciTypeId === val || item.ciTypeId === this.currentSelectData.id) {
          stateMachineSet.add(item.stateMachine)
        }
      })
      const { statusCode, data } = await getStateMachine(Array.from(stateMachineSet))
      if (statusCode === 'OK') {
        if (data.length === 1) {
          const stateString = JSON.stringify(data[0].states)
          this.stateConfig.keyOption = JSON.parse(stateString)
          this.stateConfig.valueOption = JSON.parse(stateString)
        } else {
          data.forEach(item => {
            if (item.id === this.currentSelectData.id) {
              this.stateConfig.keyOption = item.states
            } else {
              this.stateConfig.valueOption = item.states
            }
          })
        }
      }
    },
    async submitCiType (editGroupAttr) {
      this.buttonLoading.submitCiType = true
      let res = await applyCiTypes(editGroupAttr)
      this.buttonLoading.submitCiType = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('apply_ci_success'),
          desc: res.message
        })
        await this.getInitGraphData()
        this.getGroupByOptions()
      }
    },
    async applyAttr (ciTypeAttrId) {
      if (!this.checkFillRule(this.editCiAttr)) {
        return
      }
      // 校验填充规则
      if (this.editCiAttr.autofillable === 'yes' && this.editCiAttr.inputType !== 'password') {
        const isAutoFillRuleCorrect = this.autoFillRuleValidate()
        if (!isAutoFillRuleCorrect) return
      }
      const isSelectOrRef = ['select', 'ref', 'multiSelect', 'multiRef'].includes(this.editCiAttr.inputType)
      this.buttonLoading.applyAttr = true
      if (this.editCiAttr.autofillable === 'no') {
        this.editCiAttr.autoFillType = 'suggest'
        this.editCiAttr.autoFillRule = ''
      }
      let updateRes = await applyCIAttr(this.currentSelectData.id, ciTypeAttrId, {
        ...this.editCiAttr,
        length: this.editCiAttr.length || 1,
        permissionUsage: isSelectOrRef && this.editCiAttr.permissionUsage === 'yes' ? 'yes' : 'no',
        autofillable: this.editCiAttr.autofillable === 'yes' && this.editCiAttr.inputType !== 'password' ? 'yes' : 'no'
      })
      if (updateRes.statusCode === 'OK') {
        this.buttonLoading.applyAttr = false
        if (updateRes.statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('apply_ci_attr_success'),
            desc: updateRes.message
          })
          await this.getInitGraphData()
          this.getCiByOptions()
        }
      } else {
        this.buttonLoading.applyAttr = false
      }
    },
    async updateCIAttrOrder () {
      const newAttrsOrder = this.currentCiTypeAttr.map((item, index) => {
        return {
          ciTypeAttrId: item.ciTypeAttrId,
          targetIndex: index
        }
      })
      const { statusCode } = await updateCIAttrOrder(this.currentSelectData.id, newAttrsOrder)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: status === 'notCreated' ? 'CI delete' : 'CI decomission',
          desc: 'Successful'
        })
      }
    },
    async deleteCI (event, element) {
      event.stopPropagation()
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        loading: true,
        'z-index': 1000000,
        onOk: async () => {
          let res = await deleteCITypeByID(element.ciTypeId)
          this.$Modal.remove()
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: status === 'notCreated' ? 'CI delete' : 'CI decomission',
              desc: res.message
            })
            await this.getInitGraphData()
            this.getGroupByOptions()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async restoreCIAttr (event, element) {
      event.stopPropagation()
      this.$Modal.confirm({
        title: this.$t('confirm_restore'),
        'z-index': 1000000,
        loading: true,
        onOk: async () => {
          let res = await restoreCIAttr(this.currentSelectData.id, element.ciTypeAttrId)
          this.$Modal.remove()
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('success'),
              desc: this.$t('success')
            })
            this.getCiByOptions()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async restoreCiTypes (event, element) {
      event.stopPropagation()
      this.$Modal.confirm({
        title: this.$t('confirm_restore'),
        'z-index': 1000000,
        loading: true,
        onOk: async () => {
          let res = await restoreCiTypes(element.ciTypeId)
          this.$Modal.remove()
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('success'),
              desc: this.$t('success')
            })
            this.getGroupByOptions()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async deleteCIAttr (event, element) {
      event.stopPropagation()
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        loading: true,
        onOk: async () => {
          let res = await deleteAttr(this.currentSelectData.id, element.ciTypeAttrId)
          this.$Modal.remove()
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: status === 'notCreated' ? 'Delete CI Attr Successful' : 'Deprecate CI Attr Successful',
              desc: res.message
            })
            this.getCiByOptions()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    openLayerModal (tag) {
      this.levelOrLayer = tag
      this.isAddNewLayerModalVisible = true
    },
    addNewLayer (formName) {
      this.$refs[formName].validate(async valid => {
        if (valid) {
          if (this.levelOrLayer === 'level') {
            await this.addLevel()
          } else {
            await this.addLayer()
          }
        }
      })
    },
    async addLayer () {
      this.buttonLoading.newLayer = true
      let payload = {
        catId: CI_LAYER,
        status: 'active',
        code: this.newLayer.addNewLayerCode,
        value: this.newLayer.addNewLayerValue
      }
      let res = await createEnumCode([payload])
      this.buttonLoading.newLayer = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('success'),
          desc: res.message
        })
      }
      this.isAddNewLayerModalVisible = false
      await this.getInitGraphData()
    },
    async addLevel () {
      this.buttonLoading.newLayer = true
      let payload = {
        catId: CI_GROUP,
        code: this.newLayer.addNewLayerCode,
        codeDescription: this.newLayer.addNewLayerDescription,
        value: this.newLayer.addNewLayerValue,
        status: 'active'
      }
      let res = await createLayer([payload])
      this.buttonLoading.newLayer = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_level_success'),
          desc: res.message
        })
      }
      this.isAddNewLayerModalVisible = false
      await this.getInitGraphData()
    },
    addLayerModalToggle (isShow) {
      if (!isShow) {
        this.newLayer = {
          addNewLayerCode: '',
          addNewLayerValue: '',
          addNewLayerDescription: ''
        }
      }
    },
    async saveCiType (form) {
      this.buttonLoading.saveCiType = true
      delete form.attributes
      delete form.status
      delete form.imgSource
      delete form.imgUploadURL
      let res = await updateCIType(this.currentSelectData.id, {
        ...form,
        id: this.currentSelectData.id
      })
      this.buttonLoading.saveCiType = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('save_ci_success'),
          desc: res.message
        })
        this.editGroupAttr.imageFile = res.data.fileName
        await this.getInitGraphData()
        this.getGroupByOptions()
      }
    },
    async addNewAttr (id) {
      if (!this.checkFillRule(this.addNewAttrForm)) {
        return
      }
      if (
        !this.addNewAttrForm.propertyName ||
        !/^[a-z][a-z0-9_]{0,48}[a-z0-9]$/.test(this.addNewAttrForm.propertyName)
      ) {
        this.$Notice.error({
          title: 'Error',
          desc: `${this.$t('ci_attribute_id') + this.$t('db_citype_id_rule_placeholder')}`
        })
        return
      }
      // 填充规则校验
      if (this.addNewAttrForm.autofillable === 'yes' && this.addNewAttrForm.inputType !== 'password') {
        const isAutoFillRuleCorrect = this.autoFillRuleValidate()
        if (!isAutoFillRuleCorrect) return
      }
      this.buttonLoading.addNewAttr = true
      const payload = {
        ...this.addNewAttrForm,
        autofillable:
          this.addNewAttrForm.autofillable === 'yes' && this.addNewAttrForm.inputType !== 'password' ? 'yes' : 'no',
        uiSearchOrder:
          this.addNewAttrForm.uiSearchOrder && this.addNewAttrForm.inputType !== 'password'
            ? this.addNewAttrForm.uiSearchOrder
            : 0
      }
      let res = await createNewCIAttr(this.currentSelectData.id, payload)
      this.buttonLoading.addNewAttr = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_ci_attr_success'),
          desc: res.message
        })
        this.isAddNewAttrModalVisible = false
        await this.getInitGraphData()
        this.getCiByOptions()
      }
    },
    autoFillRuleValidate (val) {
      let res = true
      const ruleList = this.$refs.autoFillRef.autoFillArray
      if (ruleList.length === 0) {
        this.$Message.warning(this.$t('auto_fill_rule') + this.$t('is_required'))
        res = false
      }
      if (ruleList.length > 0) {
        const lastRule = ruleList[ruleList.length - 1]
        if (['specialDelimiter', 'calcSymbol', 'calcFunc'].includes(lastRule.type)) {
          this.$Message.warning(this.$t('auto_fill_rule') + this.$t('end_with_symbol'))
          res = false
        }
      }
      return res
    },
    addAttrModalToggle (isShow) {
      if (!isShow) {
        this.addNewAttrForm = {
          referenceId: '',
          permissionUsage: 'no',
          autofillable: 'no',
          displayByDefault: 'no',
          editable: 'yes',
          uiNullable: 'yes',
          autoFillType: 'suggest',
          uniqueConstraint: 'no',
          confirmNullable: 'yes',
          nullable: 'no',
          resetOnEdit: 'no',
          uiSearchOrder: 0
        }
      }
    },
    async addNewAttrHandler () {
      if (this.currentSelectData.type === 'GROUP') {
        this.openAddNewCITypeModal()
      } else {
        // await this.getCatOptions()
        this.buttonLoading.addNewAttrHandler = true
        this.getAllReferenceTypesList()
        this.isAddNewAttrModalVisible = true
      }
    },
    editName () {
      if (this.currentSelectData.type === 'GROUP') {
        this.isEditLayerNameModalVisible = true
      } else {
        this.isEditCINameModalVisible = true
      }
    },
    async openAddNewCITypeModal () {
      let [ciTemplate] = await Promise.all([getCiTemplate()])
      if (ciTemplate.statusCode === 'OK') {
        this.ciTemplateOptions = ciTemplate.data
      }
      this.isAddNewCITypeModalVisible = true
      this.$refs.addNewCITypeForm.resetFields()
    },
    addCiTypeModalToggle (isShow) {
      if (!isShow) {
        this.addNewCITypeForm = {
          ciLayer: null,
          ciGroup: this.addNewCITypeForm.ciGroup,
          imageFileId: undefined
        }
        this.$refs['addNewCITypeForm'].resetFields()
      } else {
        this.addNewCITypeForm.ciGroup = this.currentSelectData.id
      }
    },
    handleUploadEdit (file) {
      const res = ['jpg', 'jpeg', 'png'].some(item => file.name.includes(item))
      if (!res) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('file_upload_tips')
        })
        return
      }
      this.editGroupAttr.fileName = file.name
      var FR = new FileReader()
      FR.onload = event => {
        const imgData = event.target.result.split(',')
        this.editGroupAttr.imageFile = imgData[1]
      }
      FR.readAsDataURL(file)
      return false
    },
    handleUpload (file) {
      const res = ['jpg', 'jpeg', 'png'].some(item => file.name.includes(item))
      if (!res) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('file_upload_tips')
        })
        return
      }
      this.addNewCITypeForm.fileName = file.name
      var FR = new FileReader()
      FR.onload = event => {
        const imgData = event.target.result.split(',')
        this.addNewCITypeForm.imageFile = imgData[1]
      }
      FR.readAsDataURL(file)
      return false
    },
    addNewCIType () {
      this.$refs['addNewCITypeForm'].validate(async valid => {
        if (valid) {
          this.buttonLoading.addNewCIType = true
          const payload = { ...this.addNewCITypeForm }
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
            // this.getAllCiTypeWithAttr()
            // this.initGraph()
            // this.getAllEnumTypes()
            await this.getInitGraphData()
            this.getGroupByOptions()
          }
        }
      })
    },
    resetAddNewCITypeForm () {
      this.addNewCITypeForm = {
        name: '',
        ciTypeId: '',
        ciLayer: null,
        ciGroup: '',
        description: '',
        imageFileId: undefined
      }
    },
    getNowFormatDate () {
      var date = new Date()
      var seperator1 = '-'
      var seperator2 = ':'
      var month = date.getMonth() + 1
      var strDate = date.getDate()
      var strHours = date.getHours()
      var strMinutes = date.getMinutes()
      var strSeconds = date.getSeconds()
      if (month >= 1 && month <= 9) {
        month = '0' + month
      }
      if (strDate >= 0 && strDate <= 9) {
        strDate = '0' + strDate
      }
      if (strHours >= 0 && strHours <= 9) {
        strHours = '0' + strHours
      }
      if (strMinutes >= 0 && strMinutes <= 9) {
        strMinutes = '0' + strMinutes
      }
      if (strSeconds >= 0 && strSeconds <= 9) {
        strSeconds = '0' + strSeconds
      }
      var currentdate =
        date.getFullYear() +
        seperator1 +
        month +
        seperator1 +
        strDate +
        ' ' +
        strHours +
        seperator2 +
        strMinutes +
        seperator2 +
        strSeconds
      return currentdate
    },
    async getAllReferenceTypesList () {
      const payload = {
        filters: [{ name: 'cat.catName', operator: 'eq', value: 'ref_type' }],
        paging: false
      }
      const res = await getSystemEnumCodesBy(payload)
      if (res.statusCode === 'OK') {
        this.allReferenceTypes = res.data
      }
    },
    orderGroup () {
      let currentciGroup = []
      if (this.currentciGroup.length > 0) {
        this.originciGroupList.forEach(item => {
          if (this.currentciGroup.includes(item.codeId)) {
            currentciGroup.push(item.codeId)
          }
        })
      } else {
        currentciGroup = this.originciGroupList.map(item => item.codeId)
      }
      return currentciGroup
    },
    async getInitGraphData () {
      this.spinShow = true
      let [ciResponse, _ciLayerList, _ciGroupList] = await Promise.all([
        getAllCITypesByLayerWithAttr(this.statusList.map(item => item.value)),
        getEnumCodesByCategoryId(CI_LAYER),
        getEnumCodesByCategoryId(CI_GROUP)
      ])
      if (ciResponse.statusCode === 'OK' && _ciLayerList.statusCode === 'OK' && _ciGroupList.statusCode === 'OK') {
        this.originciLayerList = _ciLayerList.data
        this.originciGroupList = _ciGroupList.data
        this.originCITypesByLayerWithAttr = ciResponse.data
        this.currentciGroup = this.orderGroup()
        this.currentciLayer = this.currentciLayer.length > 0 ? this.currentciLayer : [_ciLayerList.data[0].codeId]

        await this.getAllCITypes()
        this.newInitGraph()
      }
    },
    async getAllCITypes () {
      const { statusCode, data } = await getAllCITypesByLayerWithAttr(['notCreated', 'created', 'dirty'])
      if (statusCode === 'OK') {
        // 初始化自动填充数据
        let allCiTypesWithAttr = []
        let allCiTypesFormatByCiTypeId = {}
        data.forEach(layer => {
          layer.ciTypes &&
            layer.ciTypes.forEach(_ => {
              allCiTypesWithAttr.push(_)
              allCiTypesFormatByCiTypeId[_.ciTypeId] = _
            })
        })
        this.allCiTypesWithAttr = allCiTypesWithAttr
        this.allCiTypesFormatByCiTypeId = allCiTypesFormatByCiTypeId
      }
    },
    // 获取extRef类型下拉选项
    async getExtRefOptions () {
      const { statusCode, data } = await getExtRefOptions()
      if (statusCode === 'OK') {
        this.extRefOptions = data || []
      }
    },
    async newInitGraph () {
      this.isOpenDrawer = false
      this.resetData()
      let graph
      const graphEl = document.getElementById('graph')
      const initEvent = () => {
        return new Promise(resolve => {
          graph = d3.select('#graph')
          graph
            .on('dblclick.zoom', null)
            .on('wheel.zoom', null)
            .on('mousewheel.zoom', null)

          this.graph.graphviz = graph
            .graphviz()
            .zoom(true)
            .fit(true)
            .height(window.innerHeight - 178)
            .width(graphEl.offsetWidth)
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
          resolve()
        })
      }
      await initEvent()
      this.$nextTick(() => {
        this.renderGraph()
      })
    },
    renderGraph () {
      let nodesString = this.genDOT()
      this.loadImage(nodesString)
      this.graph.graphviz
        .transition()
        .renderDot(nodesString)
        .on('end', () => {
          this.shadeAll()
          addEvent('svg', 'mouseover', e => {
            this.shadeAll()
            e.preventDefault()
            e.stopPropagation()
          })
          addEvent('.node', 'mouseover', this.handleNodeMouseover)
          addEvent('.node', 'click', this.handleNodeClick)
        })
      this.spinShow = false
    },
    // 初始化所有数据
    resetData () {
      this.currentCiTypeAttr = []
      this.currentGroupAttr = []
      // this.currentSelectData = {
      //   id: '',
      //   displayName: '',
      //   type: ''
      // }
    },
    handleNodeClick (e) {
      this.isOpenDrawer = false
      if (this.isHandleNodeClick) return
      this.isHandleNodeClick = true
      this.n = e.currentTarget
      // 选中group or ci
      this.isLayerSelected = this.g.getAttribute('class').indexOf('group') >= 0
      // TODO 区分获取右侧数据
      const idAndName = this.n.id.split('##')
      // 清除操作区数据
      this.currentCiTypeAttr = []
      this.currentGroupAttr = []
      this.currentSelectData = {
        id: idAndName[0],
        displayName: idAndName[1]
      }
      if (this.isLayerSelected) {
        this.currentSelectData.type = 'GROUP'
        this.getGroupByOptions()
      } else {
        // this.getCiTypeAttributes(this.currentSelectData.id)
        this.currentSelectData.type = 'CI'
        this.getCiByOptions()
        this.getAllReferenceTypesList()
      }
      // this.renderRightPanels()
      setTimeout(() => {
        this.isHandleNodeClick = false
      }, 500)
    },
    async getGroupByOptions () {
      const payload = {
        group: this.currentSelectData.id,
        currentStatus: this.currentStatus,
        currentciLayer: this.currentciLayer
      }
      const { statusCode, data } = await getGroupByOptions(payload)
      if (statusCode === 'OK') {
        this.currentGroupAttr = data[0].ciTypes
      }
    },
    async getCiByOptions () {
      const { statusCode, data } = await getCiByOptions(this.currentSelectData.id)
      if (statusCode === 'OK') {
        this.currentCiTypeAttr = data[0].attributes
        this.oriCurrentCiTypeAttr = JSON.parse(JSON.stringify(data[0].attributes))
      }
    },
    async editCIName () {
      const payload = {
        ciTypeId: this.currentSelectData.id,
        name: this.currentSelectData.displayName
      }
      let res = await updateCIType(payload.ciTypeId, payload)
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('update_ci_name_success'),
          desc: res.message
        })
        await this.getInitGraphData()
        this.getCiByOptions()
      }
    },
    async editLayerName () {
      let res = await updateLayer([
        {
          codeId: this.currentSelectData.id,
          value: this.currentSelectData.displayName
        }
      ])
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('edit_layer_name_success'),
          desc: res.message
        })
        await this.getInitGraphData()
        this.getGroupByOptions()
      }
    },
    async openDrawer (type, element, index) {
      this.editCiAttr = {}
      this.editGroupAttr = {}
      let [ciTemplate] = await Promise.all([getCiTemplate()])
      if (ciTemplate.statusCode === 'OK') {
        this.ciTemplateOptions = ciTemplate.data
      }
      this.$nextTick(() => {
        this.getCatOptions()
        if (type === 'CI') {
          this.currentCiTypeAttr.forEach(item => {
            delete item.isActive
          })
          this.currentCiTypeAttr[index].isActive = true
          this.editCiAttr = JSON.parse(JSON.stringify(element))
          // this.getCatOptions()
        }
        if (type === 'GROUP') {
          this.currentGroupAttr.forEach(item => {
            delete item.isActive
          })
          this.currentGroupAttr[index].isActive = true
          this.editGroupAttr = JSON.parse(JSON.stringify(element))
        }
        this.isOpenDrawer = true
      })
    },
    closeDrawer () {
      this.editCiAttr = {}
      this.editGroupAttr = {}
      this.isOpenDrawer = false
    },
    async saveAttr (ciTypeAttrId) {
      if (!this.checkFillRule(this.editCiAttr)) {
        return
      }
      // 校验填充规则
      if (this.editCiAttr.autofillable === 'yes' && this.editCiAttr.inputType !== 'password') {
        const isAutoFillRuleCorrect = this.autoFillRuleValidate()
        if (!isAutoFillRuleCorrect) return
      }
      this.buttonLoading.saveAttr = true
      const isSelectOrRef = ['select', 'ref', 'multiSelect', 'multiRef'].includes(this.editCiAttr.inputType)
      if (this.editCiAttr.autofillable === 'no') {
        this.editCiAttr.autoFillType = 'suggest'
        this.editCiAttr.autoFillRule = ''
      }
      let payload = {
        ...this.editCiAttr,
        length: this.editCiAttr.length || 1,
        permissionUsage: isSelectOrRef && this.editCiAttr.permissionUsage === 'yes' ? 'yes' : 'no',
        autofillable: this.editCiAttr.autofillable === 'yes' && this.editCiAttr.inputType !== 'password' ? 'yes' : 'no'
      }
      delete payload.status
      delete payload.ciType
      let res = await updateCIAttr(this.currentSelectData.id, ciTypeAttrId, payload)
      this.buttonLoading.saveAttr = false
      if (res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('save_ci_attr_success'),
          desc: res.message
        })
        if (['ref', 'multiRef'].includes(this.editCiAttr.inputType)) {
          await this.getInitGraphData()
        }
        this.getCiByOptions()
      }
    },
    checkFillRule (form) {
      if (form.autofillable === 'yes' && (form.autoFillRule === null || form.autoFillRule === undefined)) {
        this.$Notice.error({
          title: 'Error',
          desc: this.$t('auto_fill_rule_incomplete')
        })
        return false
      } else {
        return true
      }
    },
    async onInputTypeChange (value, type) {
      if (!value) return
      const inputType = this.allInputTypes.find(item => item.code === value)
      this[type].propertyType = inputType.value || ''
      if (inputType.length) {
        this[type].length = inputType.length
      }
      if (type === 'addNewAttrForm') {
        this[type].sensitive = 'no'
      }
    },
    loadImage (nodesString) {
      const xx = (nodesString.match(/image=[^,]*(files\/\d*|png)/g) || []).filter((value, index, self) => {
        return self.indexOf(value) === index
      })
      const x2 = xx.map(keyvaluepaire => {
        return keyvaluepaire.substr(7)
      })

      x2.forEach(image => {
        this.graph.graphviz.addImage(image, '48px', '48px')
      })
    },
    genDOT () {
      // data,groups,layers,status
      const status = this.currentStatus
      const groups = this.currentciGroup
      const layers = this.currentciLayer
      const data = this.originCITypesByLayerWithAttr
      var groupSet = new Set(groups)
      var layerSet = new Set()
      var ciTypeSet = new Set()
      var statusSet = new Set(status)
      var refSet = new Set()
      var groupDot = '{ node[];'
      groups.forEach((group, index) => {
        if (index === groups.length - 1) {
          groupDot += '"' + group + '"[penwidth=0]}; '
        } else {
          groupDot += '"' + group + '"->'
        }
      })
      layers.forEach(layer => {
        layerSet.add(layer.codeId)
      })
      var dot = ''
      var statusColors = new Map([
        ['created', 'black'],
        ['notCreated', 'green4'],
        ['dirty', 'dodgerblue'],
        ['deleted', 'firebrick3']
      ])
      dot =
        'digraph{bgcolor="transparent";ranksep=1.1;nodesep=.7;size="11,8";rankdir=TB\nNode [fontname=Arial, shape="ellipse", fixedsize="true", width="1.1", height="1.1", color="transparent" ,fontsize=12];\nEdge [fontname=Arial, minlen="1", color="#7f8fa6", fontsize=10];\n'
      data.forEach(dataGroup => {
        if (groupSet.has(dataGroup.codeId)) {
          dot +=
            '{rank=same;\n"' +
            dataGroup.codeId +
            '"[id="' +
            dataGroup.codeId +
            '##' +
            dataGroup.value +
            '";class="group";label="' +
            dataGroup.value +
            '";tooltip="' +
            dataGroup.value +
            '"];\n'
          dataGroup.ciTypes.forEach(ciType => {
            if (
              layerSet.has(ciType.codeId) &&
              statusSet.has(ciType.status) &&
              this.currentciLayer.includes(ciType.ciLayer)
            ) {
              dot +=
                '"' +
                ciType.ciTypeId +
                '"[id="' +
                ciType.ciTypeId +
                '##' +
                ciType.name +
                '",label="' +
                ciType.name +
                '";tootip="' +
                ciType.description +
                '";class="ci";' +
                'fontcolor="' +
                statusColors.get(ciType.status) +
                '";image="/wecmdb/fonts/' +
                ciType.imageFile +
                '";labelloc="b"]\n'
              ciTypeSet.add(ciType.ciTypeId)
              ciType.attributes.forEach(attr => {
                if (attr.inputType === 'ref' || attr.inputType === 'multiRef') {
                  refSet.add(attr)
                }
              })
            }
          })
          dot += '}\n'
        }
      })
      refSet.forEach(ref => {
        if (ciTypeSet.has(ref.referenceId) && statusSet.has(ref.status)) {
          dot +=
            '"' +
            ref.ciTypeId +
            '"->"' +
            ref.referenceId +
            '"[taillabel="' +
            ref.referenceName +
            '";labeldistance=3;fontcolor="' +
            statusColors.get(ref.status) +
            '"]\n'
        }
      })
      dot += groupDot + '}'
      return dot
    },
    handleNodeMouseover (e) {
      e.preventDefault()
      e.stopPropagation()
      d3.selectAll('g').attr('cursor', 'pointer')
      this.g = e.currentTarget
      this.nodeName = this.g.firstElementChild.textContent.trim()
      this.shadeAll()
      this.colorNode(this.nodeName)
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
    }
  },
  mounted () {
    this.getCatOptions()
    this.getInitGraphData()
    this.getExtRefOptions()
  }
}
</script>

<style lang="scss">
.cmdb-model-management-left-card .ivu-card-body {
  padding: 0;
}
.add_new_ci_type_form,
.validation-form {
  .ivu-form-item {
    margin-bottom: 20px;
  }
}
.validation-form {
  .no-need-validation {
    .ivu-form-item-label:before {
      content: ' ';
      display: inline-block;
      margin-right: 4px;
      line-height: 1;
    }
  }
  .ivu-form-item-label:before {
    content: '*';
    display: inline-block;
    margin-right: 4px;
    line-height: 1;
    font-size: 12px;
    color: #FF4D4F;
  }
}
</style>
<style lang="scss" scoped>
.custom-modal-header {
  display: flex;
  justify-content: flex-end;
  margin-top: 3px;
  margin-right: 30px;
  cursor: pointer;
}
.search-item {
  width: 260px;
}
.ivu-card-head p {
  height: 36px !important;
}
.file-content {
  position: absolute;
  z-index: 10;
  right: calc(100% * (5 / 24) + 20px);
  background: #f5f5f5;
  width: 460px;
  font-weight: 600;
  padding-left: 8px;
  color: #7e9192;
  height: calc(100vh - 108px);
  overflow: auto;
  border: 1px solid #7cd8f9;
}

// .cmdb-model-management-left-card ::v-deep .ivu-card-body {
//   padding: 0;
// }
.attrContainer {
  overflow: auto;
  height: calc(100vh - 205px);
}
.ivu-card-head p {
  height: 30px;
  line-height: 30px;
}
#graph {
  position: relative;
  height: calc(100vh - 200px);
}
.graph-container {
  overflow: hidden;
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
  font-size: 14px;
  width: 50px;
  display: inline-block;
  margin-right: 10px;
  font-weight: 400;
  text-align: right;
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
// .validation-form ::v-deep .ivu-form-item {
//   margin-bottom: 10px;
// }
.filter-col {
  align-items: center;
  display: flex;
  height: 32px;
  margin-right: 12px;
  &-icon {
    margin-right: 5px;
  }
}
// ::v-deep .validation-form {
//   .no-need-validation {
//     .ivu-form-item-label:before {
//       content: ' ';
//       display: inline-block;
//       margin-right: 4px;
//       line-height: 1;
//     }
//   }
//   .ivu-form-item-label:before {
//     content: '*';
//     display: inline-block;
//     margin-right: 4px;
//     line-height: 1;
//     font-size: 12px;
//     color: #FF4D4F;
//   }
// }
.btn-add-c {
  height: 30px;
  width: 30px;
  margin-left: 8px;
}
.element-active {
  background: #7cd8f9;
}
.attr-detail {
  max-height: calc(100vh - 160px);
  overflow: auto;
}
</style>
