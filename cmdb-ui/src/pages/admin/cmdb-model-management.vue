<template>
  <Row>
    <Col span="18">
      <div style="padding-right: 20px">
        <Card>
          <Row slot="title">
            <Col span="10">
              <p>
                架构图
                <span class="header-buttons-container margin-left">
                  <Tooltip content="新增层" placement="top-start">
                    <Button
                      size="small"
                      @click="isAddNewLayerModalVisible = true"
                      icon="md-add"
                    ></Button>
                  </Tooltip>
                </span>
              </p>
            </Col>
            <Col span="13" offset="1">
              <span class="filter-title">状态</span>
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
          <Modal
            v-model="isAddNewLayerModalVisible"
            title="新增层"
            @on-visible-change="addLayerModalToggle"
          >
            <Form
              class="validation-form"
              ref="newLayerForm"
              :model="newLayer"
              label-position="left"
              :label-width="100"
            >
              <FormItem label="Key" prop="addNewLayerCode">
                <Input v-model="newLayer.addNewLayerCode" />
              </FormItem>
              <FormItem label="Value" prop="addNewLayerValue">
                <Input v-model="newLayer.addNewLayerValue" />
              </FormItem>
              <FormItem label="描述说明" prop="addNewLayerDescription">
                <Input v-model="newLayer.addNewLayerDescription" />
              </FormItem>
            </Form>
            <div slot="footer">
              <Button type="primary" @click="addNewLayer('newLayerForm')"
                >提交</Button
              >
            </div>
          </Modal>
        </Card>
      </div>
    </Col>
    <Col
      span="6"
      offset="0"
      class="func-wrapper"
      v-if="
        JSON.stringify(currentSelectedLayer) !== '{}' ||
          JSON.stringify(currentSelectedCI) !== '{}'
      "
    >
      <Card v-if="isLayerSelected">
        <Row slot="title">
          <Col span="6">
            <p>{{ currentSelectedLayer.name }}</p>
          </Col>
          <span class="header-buttons-container">
            <Tooltip content="新增CI类型" placement="top-start">
              <Button
                size="small"
                @click="isAddNewCITypeModalVisible = true"
                icon="md-add"
              ></Button>
            </Tooltip>
            <Tooltip content="编辑层名称" placement="top-start">
              <Button
                size="small"
                @click="isEditLayerNameModalVisible = true"
                icon="md-build"
              ></Button>
            </Tooltip>
            <Tooltip content="上移层" placement="top-start">
              <Button
                size="small"
                @click="upLayer(currentSelectedLayer.layerId)"
                icon="md-arrow-round-up"
              ></Button>
            </Tooltip>
            <Tooltip content="下移层" placement="top-start">
              <Button
                size="small"
                @click="downLayer(currentSelectedLayer.layerId)"
                icon="md-arrow-round-down"
              ></Button>
            </Tooltip>
            <Tooltip content="删除层" placement="top-start">
              <Button
                size="small"
                @click="deleteLayer(currentSelectedLayer.layerId)"
                icon="ios-trash"
              ></Button>
            </Tooltip>
          </span>
        </Row>
        <Collapse accordion>
          <Panel
            v-for="(item, index) in currentSelectLayerChildren.ciTypes"
            :key="item.ciTypeId"
            :name="index.toString()"
          >
            <span
              :class="
                item.status === 'decommissioned' ? 'decommissionedLabel' : ''
              "
              >{{ item.name }}</span
            >
            <span class="header-buttons-container margin-right">
              <Tooltip
                v-if="item.status === 'decommissioned'"
                content="回滚"
                placement="top-start"
              >
                <Button
                  size="small"
                  @click.stop.prevent="revertCI(item.ciTypeId)"
                  icon="md-redo"
                ></Button>
              </Tooltip>
              <Tooltip v-else content="删除CI" placement="top-start">
                <Button
                  size="small"
                  @click.stop.prevent="deleteCI(item.ciTypeId, item.status)"
                  icon="ios-trash"
                ></Button>
              </Tooltip>
            </span>
            <div slot="content">
              <Form
                class="validation-form"
                :model="item.form"
                label-position="left"
                :label-width="100"
              >
                <FormItem label="CI类型ID" prop="tableName">
                  <Input v-model="item.form.tableName" disabled></Input>
                </FormItem>
                <FormItem label="所属层级">
                  <Select
                    v-model="item.form.layerId"
                    :disabled="item.form.status === 'decommissioned'"
                  >
                    <Option
                      v-for="layer in layers"
                      :value="layer.layerId"
                      :key="layer.layerId"
                      >{{ layer.name }}</Option
                    >
                  </Select>
                </FormItem>
                <FormItem label="描述说明" prop="description">
                  <Input
                    v-model="item.form.description"
                    :disabled="item.form.status === 'decommissioned'"
                  ></Input>
                </FormItem>
                <FormItem label="图标">
                  <img
                    :src="item.form.imgSource + '.png'"
                    style="width:58px;height:58px"
                  />
                  <Upload
                    v-if="item.form.status !== 'decommissioned'"
                    ref="upload"
                    :on-success="handleUploadImgSuccess"
                    :show-upload-list="false"
                    accept=".png"
                    :max-size="100"
                    :on-exceeded-size="handleMaxSize"
                    type="drag"
                    :action="item.form.imgUploadURL || ''"
                    :headers="setUploadActionHeader"
                    style="display: inline-block;width:58px;"
                  >
                    <div style="width: 58px;height:58px;line-height: 58px;">
                      <Icon type="ios-camera" size="20"></Icon>
                    </div>
                  </Upload>
                </FormItem>
                <FormItem>
                  <Button
                    type="primary"
                    small
                    @click="saveCiType(item.ciTypeId, item.form)"
                    :disabled="item.form.status !== 'notCreated'"
                    >暂存</Button
                  >
                  <Button
                    type="primary"
                    small
                    @click="submitCiType(item.ciTypeId, item.form)"
                    style="margin-left: 8px"
                    :disabled="item.form.status === 'decommissioned'"
                    >提交</Button
                  >
                </FormItem>
              </Form>
            </div>
          </Panel>
        </Collapse>
        <Modal
          v-model="isAddNewCITypeModalVisible"
          title="新增CI类型"
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
            <FormItem label="名称" prop="name">
              <Input v-model="addNewCITypeForm.name"></Input>
            </FormItem>
            <FormItem label="CI类型ID" prop="tableName">
              <Input v-model="addNewCITypeForm.tableName"></Input>
            </FormItem>
            <FormItem label="所属层级">
              <Select disabled v-model="addNewCITypeForm.layerId">
                <Option
                  v-for="layer in layers"
                  :value="layer.layerId"
                  :key="layer.layerId"
                  >{{ layer.name }}</Option
                >
              </Select>
            </FormItem>
            <FormItem label="描述说明" prop="description">
              <Input v-model="addNewCITypeForm.description"></Input>
            </FormItem>
            <FormItem label="图标">
              <img
                v-if="addNewCITypeForm.imageFileId !== 0"
                :src="`/cmdb/ui/v2/files/${addNewCITypeForm.imageFileId}`"
                style="width:58px;height:58px"
              />
              <Upload
                ref="upload"
                :on-success="handleNewCITypeUploadImgSuccess"
                :show-upload-list="false"
                accept=".png"
                :max-size="100"
                :on-exceeded-size="handleMaxSize"
                type="drag"
                action="/cmdb/ui/v2/files/upload"
                :headers="setUploadActionHeader"
                style="display: inline-block;width:58px;"
              >
                <div style="width: 58px;height:58px;line-height: 58px;">
                  <Icon type="ios-camera" size="20"></Icon>
                </div>
              </Upload>
            </FormItem>
            <FormItem>
              <Button
                type="primary"
                small
                @click="addNewCIType"
                style="float: right"
                >确认</Button
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
            <Tooltip content="新增CI属性" placement="top-start">
              <Button
                size="small"
                @click="addNewAttrHandler"
                icon="md-add"
              ></Button>
            </Tooltip>
            <Tooltip content="编辑名称" placement="top-start">
              <Button
                size="small"
                @click="isEditCINameModalVisible = true"
                icon="md-build"
              ></Button>
            </Tooltip>
          </span>
        </Row>
        <Collapse accordion @on-change="onCIAttrCollapeOpen">
          <Panel
            v-for="(item, index) in currentSelectedCIChildren"
            :key="item.ciTypeAttrId"
            :name="item.ciTypeAttrId.toString()"
            v-if="!item.isHidden"
          >
            <span
              :class="
                item.status === 'decommissioned' ? 'decommissionedLabel' : ''
              "
              >{{ item.name }}</span
            >
            <span class="header-buttons-container margin-right">
              <Tooltip content="上移CI属性" placement="top-start">
                <Button
                  size="small"
                  @click.stop.prevent="moveUpAttr(item.ciTypeAttrId)"
                  icon="md-arrow-round-up"
                ></Button>
              </Tooltip>
              <Tooltip content="下移CI属性" placement="top-start">
                <Button
                  size="small"
                  @click.stop.prevent="moveDownAttr(item.ciTypeAttrId)"
                  icon="md-arrow-round-down"
                ></Button>
              </Tooltip>
              <Tooltip
                v-if="item.status === 'decommissioned'"
                content="回滚"
                placement="top-start"
              >
                <Button
                  size="small"
                  @click.stop.prevent="revertCIAttr(item.ciTypeAttrId)"
                  icon="md-redo"
                ></Button>
              </Tooltip>
              <Tooltip v-else content="删除CI属性" placement="top-start">
                <Button
                  size="small"
                  @click.stop.prevent="
                    deleteCIAttr(item.ciTypeAttrId, item.status)
                  "
                  icon="ios-trash"
                ></Button>
              </Tooltip>
            </span>
            <div slot="content">
              <Form
                class="validation-form"
                ref="ciAttrForm"
                v-model="item.form"
                label-position="left"
                :label-width="120"
              >
                <FormItem prop="propertyName" label="CI属性ID">
                  <Input v-model="item.form.propertyName" disabled></Input>
                </FormItem>
                <FormItem prop="name" label="CI属性名称">
                  <Input
                    v-model="item.form.name"
                    :disabled="item.form.status === 'decommissioned'"
                  ></Input>
                </FormItem>
                <FormItem label="搜索条件排序序号" prop="searchSeqNo">
                  <InputNumber
                    :min="0"
                    :disabled="item.form.status === 'decommissioned'"
                    v-model="item.form.searchSeqNo"
                  ></InputNumber>
                </FormItem>
                <FormItem prop="inputType" label="数据类型">
                  <Select
                    v-model="item.form.inputType"
                    @on-change="
                      onInputTypeChange(
                        $event,
                        item.form.status !== 'notCreated'
                      )
                    "
                    :disabled="item.form.status !== 'notCreated'"
                  >
                    <Option
                      v-for="item in allInputTypes"
                      :value="item"
                      :key="item"
                      >{{ item }}</Option
                    >
                  </Select>
                </FormItem>
                <FormItem label="真实类型">
                  <Input v-model="item.form.propertyType" disabled></Input>
                </FormItem>
                <FormItem
                  prop="length"
                  label="长度"
                  v-if="
                    item.form.inputType === 'text' ||
                      item.form.inputType === 'textArea'
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
                  v-if="
                    item.form.inputType === 'ref' ||
                      item.form.inputType === 'multiRef'
                  "
                  label="引用选择"
                >
                  <Select
                    v-model="item.form.referenceId"
                    :disabled="item.form.status === 'decommissioned'"
                  >
                    <Option
                      v-for="item in allCiTypes"
                      :value="item.ciTypeId"
                      :key="item.ciTypeId"
                      >{{ item.name }}</Option
                    >
                  </Select>
                </FormItem>
                <FormItem
                  prop="referenceName"
                  v-if="
                    item.form.inputType === 'ref' ||
                      item.form.inputType === 'multiRef'
                  "
                  label="引用命名"
                >
                  <Input
                    v-model="item.form.referenceName"
                    :disabled="item.form.status === 'decommissioned'"
                  ></Input>
                </FormItem>
                <FormItem
                  prop="referenceType"
                  v-if="
                    item.form.inputType === 'ref' ||
                      item.form.inputType === 'multiRef'
                  "
                  label="引用类型"
                >
                  <Select
                    v-model="item.form.referenceType"
                    :disabled="item.form.status === 'decommissioned'"
                  >
                    <Option
                      v-for="item in allReferenceTypes"
                      :value="item.codeId"
                      :key="item.codeId"
                      >{{ item.value }}</Option
                    >
                  </Select>
                </FormItem>
                <FormItem
                  prop="referenceId"
                  v-if="
                    item.form.inputType === 'select' ||
                      item.form.inputType === 'multiSelect'
                  "
                  label="枚举选择"
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
                      >{{ `[${"system"}] ${enumItem.catName}` }}</Option
                    >
                  </Select>

                  <Select
                    v-else
                    clearable
                    v-model="item.form.referenceId"
                    :disabled="item.form.status === 'decommissioned'"
                  >
                    <span
                      slot="prefix"
                      @click.stop.prevent="openEnumGroupModal(null)"
                      >@+</span
                    >
                    <Option
                      v-for="enumItem in currentSelectedCIAttrEnum"
                      :value="enumItem.catId"
                      :key="enumItem.catId"
                      style="max-width: 300px"
                    >
                      {{
                        `[${enumItem.catTypeId === 2 ? "common" : "private"}] ${
                          enumItem.catName
                        }`
                      }}
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
                <FormItem prop="isRefreshable" label="是否复用">
                  <RadioGroup v-model="item.form.isRefreshable">
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="yes"
                      >Yes</Radio
                    >
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="no"
                      >No</Radio
                    >
                  </RadioGroup>
                </FormItem>
                <FormItem prop="isDisplayed" label="显示在表">
                  <RadioGroup v-model="item.form.isDisplayed">
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="yes"
                      >Yes</Radio
                    >
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="no"
                      >No</Radio
                    >
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
                  label="权限控制"
                >
                  <RadioGroup v-model="item.form.isAccessControlled">
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="yes"
                      >Yes</Radio
                    >
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="no"
                      >No</Radio
                    >
                  </RadioGroup>
                </FormItem>
                <FormItem prop="isNullable" label="允许为空">
                  <RadioGroup v-model="item.form.isNullable">
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="yes"
                      >Yes</Radio
                    >
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="no"
                      >No</Radio
                    >
                  </RadioGroup>
                </FormItem>
                <FormItem prop="isEditable" label="是否可编辑">
                  <RadioGroup v-model="item.form.isEditable">
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="yes"
                      >Yes</Radio
                    >
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="no"
                      >No</Radio
                    >
                  </RadioGroup>
                </FormItem>
                <FormItem prop="isAuto" label="自动填充">
                  <RadioGroup v-model="item.form.isAuto">
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="yes"
                      >Yes</Radio
                    >
                    <Radio
                      :disabled="item.form.status === 'decommissioned'"
                      label="no"
                      >No</Radio
                    >
                  </RadioGroup>
                </FormItem>
                <FormItem
                  prop="autoFillRule"
                  v-if="item.form.isAuto === 'yes'"
                  label="填充规则"
                >
                  <AutoFill
                    :allLayers="source"
                    :rootCiTypeId="item.ciTypeId"
                    v-model="item.form.autoFillRule"
                    :disabled="item.form.status === 'decommissioned'"
                  ></AutoFill>
                </FormItem>
                <FormItem
                  class="no-need-validation"
                  v-if="
                    item.form.inputType === 'ref' ||
                      item.form.inputType === 'select'
                  "
                  label="过滤规则"
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
                    style="float: right"
                    :disabled="item.form.status === 'decommissioned'"
                    >提交</Button
                  >
                  <Button
                    type="primary"
                    small
                    @click="saveAttr(item.ciTypeAttrId, item.form)"
                    style="float: right; margin-right: 20px"
                    :disabled="item.form.status !== 'notCreated'"
                    >暂存</Button
                  >
                </FormItem>
              </Form>
            </div>
          </Panel>
        </Collapse>
        <Modal
          v-model="isAddNewAttrModalVisible"
          title="新增CI属性"
          @on-visible-change="addAttrModalToggle"
          footer-hide
        >
          <Form
            class="validation-form"
            ref="ciAttrForm"
            :model="addNewAttrForm"
            label-position="left"
            :label-width="120"
          >
            <FormItem label="CI属性名称" prop="name">
              <Input v-model="addNewAttrForm.name"></Input>
            </FormItem>
            <FormItem prop="propertyName" label="CI属性ID">
              <Input v-model="addNewAttrForm.propertyName"></Input>
            </FormItem>
            <FormItem label="搜索条件排序序号">
              <InputNumber
                :min="0"
                v-model="addNewAttrForm.searchSeqNo"
              ></InputNumber>
            </FormItem>
            <FormItem prop="inputType" label="数据类型">
              <Select
                v-model="addNewAttrForm.inputType"
                @on-change="onInputTypeChange($event, false)"
              >
                <Option
                  v-for="item in allInputTypes"
                  :value="item"
                  :key="item"
                  >{{ item }}</Option
                >
              </Select>
            </FormItem>
            <FormItem prop="propertyType" label="真实类型">
              <Input v-model="addNewAttrForm.propertyType" disabled></Input>
            </FormItem>
            <FormItem
              prop="length"
              label="长度"
              v-if="
                addNewAttrForm.inputType === 'text' ||
                  addNewAttrForm.inputType === 'textArea'
              "
            >
              <InputNumber
                :min="1"
                v-model="addNewAttrForm.length"
              ></InputNumber>
            </FormItem>
            <FormItem
              prop="referenceId"
              v-if="
                addNewAttrForm.inputType === 'ref' ||
                  addNewAttrForm.inputType === 'multiRef'
              "
              label="引用选择"
            >
              <Select v-model="addNewAttrForm.referenceId">
                <Option
                  v-for="item in allCiTypes"
                  :value="item.ciTypeId"
                  :key="item.ciTypeId"
                  >{{ item.name }}</Option
                >
              </Select>
            </FormItem>
            <FormItem
              prop="referenceName"
              v-if="
                addNewAttrForm.inputType === 'ref' ||
                  addNewAttrForm.inputType === 'multiRef'
              "
              label="引用命名"
            >
              <Input v-model="addNewAttrForm.referenceName"></Input>
            </FormItem>
            <FormItem
              prop="referenceType"
              v-if="
                addNewAttrForm.inputType === 'ref' ||
                  addNewAttrForm.inputType === 'multiRef'
              "
              label="引用类型"
            >
              <Select v-model="addNewAttrForm.referenceType">
                <Option
                  v-for="item in allReferenceTypes"
                  :value="item.codeId"
                  :key="item.codeId"
                  >{{ item.value }}</Option
                >
              </Select>
            </FormItem>
            <FormItem
              prop="referenceId"
              v-if="
                addNewAttrForm.inputType === 'select' ||
                  addNewAttrForm.inputType === 'multiSelect'
              "
              label="枚举选择"
            >
              <Select clearable v-model="addNewAttrForm.referenceId">
                <span
                  slot="prefix"
                  @click.stop.prevent="openEnumGroupModal(null)"
                  >@+</span
                >
                <Option
                  v-for="item in currentSelectedCIAttrEnum"
                  :value="item.catId"
                  :key="item.catId"
                >
                  {{
                    `[${item.catTypeId === 2 ? "common" : "private"}] ${
                      item.catName
                    }`
                  }}
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
            <FormItem prop="isRefreshable" label="是否复用">
              <RadioGroup v-model="addNewAttrForm.isRefreshable">
                <Radio label="yes">Yes</Radio>
                <Radio label="no">No</Radio>
              </RadioGroup>
            </FormItem>
            <FormItem prop="isDisplayed" label="显示在表">
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
              label="权限控制"
            >
              <RadioGroup v-model="addNewAttrForm.isAccessControlled">
                <Radio label="yes">Yes</Radio>
                <Radio label="no">No</Radio>
              </RadioGroup>
            </FormItem>
            <FormItem prop="isNullable" label="允许为空">
              <RadioGroup v-model="addNewAttrForm.isNullable">
                <Radio label="yes">Yes</Radio>
                <Radio label="no">No</Radio>
              </RadioGroup>
            </FormItem>
            <FormItem prop="isEditable" label="是否可编辑">
              <RadioGroup v-model="addNewAttrForm.isEditable">
                <Radio label="yes">Yes</Radio>
                <Radio label="no">No</Radio>
              </RadioGroup>
            </FormItem>
            <FormItem prop="isAuto" label="自动填充">
              <RadioGroup v-model="addNewAttrForm.isAuto">
                <Radio label="yes">Yes</Radio>
                <Radio label="no">No</Radio>
              </RadioGroup>
            </FormItem>
            <FormItem
              prop="layerId"
              v-if="addNewAttrForm.isAuto === 'yes'"
              label="填充规则"
            >
              <AutoFill
                :allLayers="source"
                :rootCiTypeId="currentSelectedCI.ciTypeId"
                v-model="addNewAttrForm.autoFillRule"
              ></AutoFill>
            </FormItem>
            <FormItem>
              <Button
                type="primary"
                small
                @click="addNewAttr"
                style="float: right"
                >提交</Button
              >
            </FormItem>
          </Form>
        </Modal>
      </Card>

      <Modal
        v-model="isEditLayerNameModalVisible"
        title="编辑层名称"
        @on-ok="editLayerName"
        @on-cancel="() => {}"
      >
        <Input v-model="updatedLayerNameValue.code" placeholder="请输入" />
      </Modal>

      <Modal
        v-model="isEditCINameModalVisible"
        title="编辑CI名称"
        @on-ok="editCIName"
        @on-cancel="() => {}"
      >
        <Input v-model="updatedCINameValue.name" placeholder="请输入" />
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
    <Col span="6" offset="0" class="func-wrapper" v-else>
      <Card>
        <Row slot="title">
          <p>编辑区</p>
        </Row>
        <p>请点击架构图进行操作</p>
      </Card>
    </Col>
  </Row>
</template>

<script>
import * as d3 from "d3-selection";
import * as d3Graphviz from "d3-graphviz";
import { addEvent } from "../util/event.js";
import {
  getAllCITypesByLayerWithAttr,
  getAllLayers,
  createLayer,
  moveUpLayer,
  moveDownLayer,
  deleteCITypeByID,
  deleteAttr,
  getImgFileByID,
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
  updateEnumCode,
  getEnumCategoriesByTypeId
} from "@/api/server";
import STATUS_LIST from "@/const/graph-status-list.js";
import { INPUT_TYPES, PROPERTY_TYPE_MAP } from "@/const/data-types.js";
import { setHeaders } from "@/api/base.js";
import enumGroupModal from "./components/enum-group-modal";
import AutoFill from "../components/auto-fill";
import FilterRule from "../components/filter-rule";

const defaultCiTypePNG = require("@/assets/ci-type-default.png");

const REQUIRED_FIELD_MESSAGE = "Field is required";
export default {
  components: {
    enumGroupModal,
    AutoFill,
    FilterRule
  },
  data() {
    return {
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
      nodeName: "",
      g: null,
      statusList: [],
      selectedStatus: ["notCreated", "created"],
      allStatus: STATUS_LIST.map(_ => _.value),
      newLayer: {
        addNewLayerCode: "",
        addNewLayerValue: "",
        addNewLayerDescription: ""
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
        imageFileId: 0
      },
      addNewAttrForm: {
        searchSeqNo: 0,
        isAccessControlled: "no",
        isRefreshable: "no",
        isDisplayed: "no",
        isNullable: "no",
        isAuto: "no",
        isEditable: "yes"
      },
      allCiTypes: [],
      allInputTypes: [],
      allReferenceTypes: [],
      selectedCIAttrIsSystem: false
    };
  },
  methods: {
    addLayerModalToggle(isShow) {
      if (!isShow) {
        this.newLayer = {
          addNewLayerCode: "",
          addNewLayerValue: "",
          addNewLayerDescription: ""
        };
      }
    },
    addCiTypeModalToggle(isShow) {
      if (!isShow) {
        this.addNewCITypeForm = {
          layerId: this.addNewCITypeForm.layerId,
          imageFileId: 0
        };
      }
    },
    addAttrModalToggle(isShow) {
      if (!isShow) {
        this.addNewAttrForm = {
          isAccessControlled: "no",
          isAuto: "no",
          isDisplayed: "no",
          isEditable: "yes",
          isNullable: "no",
          isRefreshable: "no",
          searchSeqNo: 0
        };
      }
    },
    openEnumGroupModal(val) {
      this.currentCategory = val;
      this.enumGroupModalVisible = true;
    },
    hideEnumGroupModal(val) {
      this.enumGroupModalVisible = false;
    },
    async initGraph(status = []) {
      let origin;
      let edges = {};
      let levels = {};
      let graph;
      let graphviz;

      const graphEl = document.getElementById("graph");
      const initEvent = () => {
        graph = d3.select("#graph");
        graph
          .on("dblclick.zoom", null)
          .on("wheel.zoom", null)
          .on("mousewheel.zoom", null);

        this.graph.graphviz = graph
          .graphviz()
          .zoom(true)
          .width(graphEl.innerWidth * 1)
          .attributer(function(d) {
            if (d.attributes.class === "edge") {
              const keys = d.key.split("->");
              const from = keys[0].trim();
              const to = keys[1].trim();
              d.attributes.from = from;
              d.attributes.to = to;
            }

            if (d.tag === "text") {
              const key = d.children[0].text;
              d3.select(this).attr("text-key", key);
            }
          });
      };

      let layerResponse = await getAllLayers();
      if (layerResponse.status === "OK") {
        let tempLayer = layerResponse.data
          .filter(i => i.status === "active")
          .map(_ => {
            return { name: _.value, layerId: _.codeId, ..._ };
          });
        this.layers = tempLayer.sort((a, b) => {
          return a.seqNo - b.seqNo;
        });
        let ciResponse = await getAllCITypesByLayerWithAttr(
          this.selectedStatus
        );
        if (ciResponse.status === "OK") {
          this.source = [];
          this.source = ciResponse.data;
          this.source.forEach(_ => {
            _.ciTypes &&
              _.ciTypes.forEach(async i => {
                let imgFileSource =
                  i.imageFileId === 0 || i.imageFileId === undefined
                    ? defaultCiTypePNG.substring(0, defaultCiTypePNG.length - 4)
                    : `/cmdb/ui/v2/files/${i.imageFileId}`;
                this.$set(i, "form", {
                  ...i,
                  imgSource: imgFileSource,
                  imgUploadURL: `/cmdb/ui/v2/ci-types/${i.ciTypeId}/icon`
                });
                i.attributes &&
                  i.attributes.forEach(j => {
                    this.$set(j, "form", {
                      ...j,
                      isRefreshable: j.isRefreshable ? "yes" : "no",
                      isDisplayed: j.isDisplayed ? "yes" : "no",
                      isAccessControlled: j.isAccessControlled ? "yes" : "no",
                      isNullable: j.isNullable ? "yes" : "no",
                      isAuto: j.isAuto ? "yes" : "no",
                      isEditable: j.isEditable ? "yes" : "no",
                      searchSeqNo: j.searchSeqNo || 0
                    });
                  });

                this.renderRightPanels();
              });
          });
          let uploadToken = document.cookie
            .split(";")
            .find(i => i.indexOf("XSRF-TOKEN") !== -1);
          setHeaders({
            "X-XSRF-TOKEN": uploadToken && uploadToken.split("=")[1]
          });
          initEvent();
          this.renderGraph(ciResponse.data);
        }
      }
    },
    genDOT(data) {
      let nodes = [];
      data.forEach(_ => {
        if (_.ciTypes) nodes = nodes.concat(_.ciTypes);
      });
      var dots = [
        "digraph  {",
        'bgcolor="transparent";',
        'Node [fontname=Arial, shape="ellipse", fixedsize="true", width="1.1", height="1.1", color="transparent" ,fontsize=12];',
        'Edge [fontname=Arial, minlen="1", color="#7f8fa6", fontsize=10];',
        'ranksep = 1.1; nodesep=.7; size = "11,8"; rankdir=TB'
      ];
      let layerTag = `node [];`;

      // generate group
      let tempClusterObjForGraph = {};
      let tempClusterAryForGraph = [];
      this.layers.map((_, index) => {
        if (index !== this.layers.length - 1) {
          layerTag += '"' + _.name + '"' + "->";
        } else {
          layerTag += '"' + _.name + '"';
        }

        tempClusterObjForGraph[index] = [`{ rank=same; "${_.name}";`];
        nodes.length > 0 &&
          nodes.forEach((node, nodeIndex) => {
            if (node.layerId === _.layerId) {
              let fontcolor =
                node.status === "notCreated" ? "#10a34e" : "black";
              tempClusterObjForGraph[index].push(
                `"${node.name}"[id="${
                  node.ciTypeId
                }",fontcolor="${fontcolor}", image="${
                  node.form.imgSource
                }.png", labelloc="b"]`
              );
            }
            if (nodeIndex === nodes.length - 1) {
              tempClusterObjForGraph[index].push("} ");
            }
          });
        if (nodes.length === 0) {
          tempClusterObjForGraph[index].push("} ");
        }
        tempClusterAryForGraph.push(tempClusterObjForGraph[index].join(""));
      });
      dots.push(tempClusterAryForGraph.join(""));
      dots.push("{" + layerTag + "[style=invis]}");

      //generate edges
      nodes.forEach(node => {
        node.attributes &&
          node.attributes.forEach(attr => {
            if (attr.inputType === "ref" || attr.inputType === "multiRef") {
              var target = nodes.find(_ => _.ciTypeId === attr.referenceId);
              if (target) {
                dots.push(this.genEdge(nodes, node, attr));
              }
            }
          });
      });
      dots.push("}");
      return dots.join("");
    },
    genEdge(nodes, from, to) {
      const target = nodes.find(_ => _.ciTypeId === to.referenceId);
      let labels = to.referenceName ? to.referenceName.trim() : "";
      return (
        '"' +
        from.name +
        '"->' +
        '"' +
        target.name.trim() +
        '"[taillabel="' +
        labels +
        '", labeldistance=3];'
      );
    },
    shadeAll() {
      d3.selectAll("g path")
        .attr("stroke", "#7f8fa6")
        .attr("stroke-opacity", ".2");
      d3.selectAll("g polygon")
        .attr("stroke", "#7f8fa6")
        .attr("stroke-opacity", ".2")
        .attr("fill", "#7f8fa6")
        .attr("fill-opacity", ".2");
      d3.selectAll(".edge text").attr("fill", "#000");
    },
    colorNode(nodeName) {
      d3.selectAll('g[from="' + nodeName + '"] path')
        .attr("stroke", "red")
        .attr("stroke-opacity", "1");
      d3.selectAll('g[from="' + nodeName + '"] text').attr("fill", "red");
      d3.selectAll('g[from="' + nodeName + '"] polygon')
        .attr("stroke", "red")
        .attr("fill", "red")
        .attr("fill-opacity", "1")
        .attr("stroke-opacity", "1");
      d3.selectAll('g[to="' + nodeName + '"] path')
        .attr("stroke", "green")
        .attr("stroke-opacity", "1");
      d3.selectAll('g[to="' + nodeName + '"] text').attr("fill", "green");
      d3.selectAll('g[to="' + nodeName + '"] polygon')
        .attr("stroke", "green")
        .attr("fill", "green")
        .attr("fill-opacity", "1")
        .attr("stroke-opacity", "1");
    },

    loadImage(nodesString) {
      (nodesString.match(/image=[^,]*(files\/\d*|png)/g) || [])
        .filter((value, index, self) => {
          return self.indexOf(value) === index;
        })
        .map(keyvaluepaire => keyvaluepaire.substr(7))
        .forEach(image => {
          this.graph.graphviz.addImage(image, "48px", "48px");
        });
    },
    renderGraph(data) {
      let nodesString = this.genDOT(data);
      this.loadImage(nodesString);
      this.graph.graphviz.renderDot(nodesString);
      addEvent("svg", "click", e => {
        e.preventDefault();
        e.stopPropagation();
        d3.selectAll("g path")
          .attr("stroke", "#7f8fa6")
          .attr("stroke-opacity", "1");
        d3.selectAll("g polygon")
          .attr("stroke", "#7f8fa6")
          .attr("stroke-opacity", "1")
          .attr("fill", "#7f8fa6")
          .attr("fill-opacity", "1");
        d3.selectAll(".edge text").attr("fill", "#000");
      });
      addEvent(".node", "click", async e => {
        e.preventDefault();
        e.stopPropagation();

        this.g = e.currentTarget;
        this.nodeName = this.g.children[0].innerHTML.trim();
        this.shadeAll();
        this.colorNode(this.nodeName);
        // d3.selectAll("g").attr("stroke", "");
        // d3.select(g).attr("stroke", "red");
        this.isLayerSelected = this.layers.find(_ => _.name === this.nodeName);
        this.renderRightPanels();
      });
      addEvent(".node", "mouseover", e => {
        e.preventDefault();
        e.stopPropagation();
        d3.selectAll("g").attr("cursor", "pointer");
      });
    },
    renderRightPanels() {
      if (!this.nodeName) return;
      if (!!this.isLayerSelected) {
        this.currentSelectedLayer = this.layers.find(
          _ => _.layerId === this.isLayerSelected.layerId
        );
        this.updatedLayerNameValue = {
          codeId: this.currentSelectedLayer.layerId,
          code: this.currentSelectedLayer.name
        };
        this.handleLayerSelect(this.currentSelectedLayer.layerId);
      } else {
        this.source.forEach(_ => {
          _.ciTypes &&
            _.ciTypes.forEach(i => {
              if (i.ciTypeId && i.ciTypeId === +this.g.id) {
                this.currentSelectedCI = i;
                this.currentSelectedCIChildren =
                  (i.attributes &&
                    i.attributes.sort((a, b) => {
                      return a.displaySeqNo - b.displaySeqNo;
                    })) ||
                  [];
              }
            });
        });
        this.updatedCINameValue = {
          ciTypeId: parseInt(this.g.id),
          name: this.currentSelectedCI.name
        };
        this.getAllEnumTypes();
        this.getAllEnumCategories();
      }
    },
    async getAllEnumCategories() {
      if (this.allEnumCategories.length === 0) {
        const { message, data, status } = await getAllEnumCategories();
        if (status === "OK") {
          this.allEnumCategories = data.contents;
        }
      }
    },
    async getAllEnumTypes() {
      if (this.allEnumCategoryTypes.length === 0) {
        const { message, data, status } = await getAllEnumCategoryTypes();
        if (status === "OK") {
          this.allEnumCategoryTypes = data;
        }
      }
    },
    handleLayerSelect(layerId) {
      this.currentSelectLayerChildren = this.source.find(
        _ => _.codeId === layerId
      );
      this.addNewCITypeForm.layerId = this.currentSelectLayerChildren.codeId;
    },
    handleStatusChange(value) {
      this.initGraph(value);
    },
    onCIAttrCollapeOpen(val) {
      this.currentSelectedCIChildren.forEach((_, index) => {
        if (
          _.ciTypeAttrId === +val[0] &&
          (_.inputType === "select" || _.inputType === "multiSelect")
        ) {
          this.selectedCIAttrIsSystem = _.isSystem;
          this.getEnum();
        }
      });
    },
    async getEnum(isNewAdd = false) {
      const SYS_ENUM_TYPE_ID = 1;
      const res =
        this.selectedCIAttrIsSystem && !isNewAdd
          ? await getEnumCategoriesByTypeId(SYS_ENUM_TYPE_ID)
          : await getEnumByCIType(this.currentSelectedCI.ciTypeId);
      if (res.status === "OK") {
        let enumList = [];
        enumList =
          this.selectedCIAttrIsSystem && !isNewAdd
            ? res.data
            : enumList
                .concat(res.data.private || [])
                .concat(res.data.common || []);
        this.currentSelectedCIAttrEnum = enumList;
      }
    },
    async onInputTypeChange(value, isDiabled) {
      this.addNewAttrForm.propertyType = PROPERTY_TYPE_MAP[value];
      if (value === "select" || (value === "multiSelect" && !isDiabled)) {
        this.getEnum(true);
      }
    },
    addNewLayer(formName) {
      this.$refs[formName].validate(async valid => {
        if (valid) {
          let payload = {
            code: this.newLayer.addNewLayerCode,
            codeDescription: this.newLayer.addNewLayerDescription,
            value: this.newLayer.addNewLayerValue
          };
          let res = await createLayer(payload);
          if (res.status === "OK") {
            this.$Notice.success({
              title: "Add Layer Success",
              desc: res.message
            });
          }
          this.isAddNewLayerModalVisible = false;
          this.initGraph();
        }
      });
    },
    async editLayerName() {
      let res = await updateLayer([
        {
          codeId: this.updatedLayerNameValue.codeId,
          value: this.updatedLayerNameValue.code
        }
      ]);
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Edit layer name success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async upLayer(id) {
      let currentIndex = this.layers.map(i => i.codeId).indexOf(id);
      if (!this.layers[currentIndex - 1]) {
        this.$Notice.warning({
          title: "Warning",
          desc: "已经是第一层"
        });
        return;
      }
      let targetID = this.layers[currentIndex - 1].codeId;
      let res = await swapLayerPosition(id, targetID);
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Move Up Layer Success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async downLayer(id) {
      let currentIndex = this.layers.map(i => i.codeId).indexOf(id);
      if (!this.layers[currentIndex + 1]) {
        this.$Notice.warning({
          title: "Warning",
          desc: "已经是最后一层"
        });
        return;
      }
      let targetID = this.layers[currentIndex + 1].codeId;
      let res = await swapLayerPosition(id, targetID);
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Move Down Layer Success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async deleteLayer(id) {
      this.$Modal.confirm({
        title: "确认删除？",
        "z-index": 1000000,
        onOk: async () => {
          const { status, message, data } = await deleteLayer(id);

          if (status === "OK") {
            this.$Notice.success({
              title: "Delete Layer Success",
              desc: message
            });
            this.initGraph();
          }
        },
        onCancel: () => {}
      });
      document.querySelector(".ivu-modal-mask").click();
    },

    async revertCI(ciTypeId) {
      let res = await implementCiType(ciTypeId, "revert");
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Revert ci type success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async revertCIAttr(attrId) {
      let res = await implementCiAttr(
        this.currentSelectedCI.ciTypeId,
        attrId,
        "revert"
      );
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Revert CI Attr Success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async editCIName() {
      let res = await updateCIType(
        this.updatedCINameValue.ciTypeId,
        this.updatedCINameValue
      );
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Edit ci type name success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async deleteCI(id, status) {
      this.$Modal.confirm({
        title: "确认删除？",
        "z-index": 1000000,
        onOk: async () => {
          let res =
            status === "notCreated"
              ? await deleteCITypeByID(id)
              : await implementCiType(id, "deco");
          if (res.status === "OK") {
            this.$Notice.success({
              title: status === "notCreated" ? "CI delete" : "CI decomission",
              desc: res.message
            });
            this.initGraph();
          }
        },
        onCancel: () => {}
      });
      document.querySelector(".ivu-modal-mask").click();
    },
    async deleteCIAttr(id, status) {
      this.$Modal.confirm({
        title: "确认删除？",
        "z-index": 1000000,
        onOk: async () => {
          let res =
            status === "notCreated"
              ? await deleteAttr(this.currentSelectedCI.ciTypeId, id)
              : await implementCiAttr(
                  this.currentSelectedCI.ciTypeId,
                  id,
                  "deco"
                );
          if (res.status === "OK") {
            this.$Notice.success({
              title:
                status === "notCreated"
                  ? "Delete CI Attr Successful"
                  : "Deprecate CI Attr Successful",
              desc: res.message
            });
            this.initGraph();
          }
        },
        onCancel: () => {}
      });
      document.querySelector(".ivu-modal-mask").click();
    },
    async saveCiType(id, form) {
      delete form.attributes;
      delete form.tableName;
      delete form.status;
      delete form.imgSource;
      delete form.imgUploadURL;
      let res = await updateCIType(id, {
        ...form,
        callbackId: "10000001"
      });
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Save CI Successful",
          desc: res.message
        });
        this.initGraph();
      }
    },
    addNewCIType() {
      this.$refs["addNewCITypeForm"].validate(async valid => {
        if (valid) {
          const payload = { ...this.addNewCITypeForm, callbackId: "10000001" };
          let res = await createNewCIType(payload);
          if (res.status === "OK") {
            this.$Notice.success({
              title: "Add New CI Type Success",
              desc: res.message
            });
            this.resetAddNewCITypeForm();
            this.isAddNewCITypeModalVisible = false;
            this.initGraph();
            this.getAllEnumTypes();
          }
        }
      });
    },
    resetAddNewCITypeForm() {
      this.addNewCITypeForm = {
        name: "",
        tableName: "",
        layerId: "",
        description: "",
        imageFileId: 0
      };
    },
    async submitCiType(id, form) {
      const isNotCreated = form.status === "notCreated";
      delete form.attributes;
      delete form.tableName;
      delete form.status;
      delete form.imgSource;
      delete form.imgUploadURL;
      let res = isNotCreated
        ? await applyCiTypes(id)
        : await updateCIType(id, {
            ...form
          });
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Apply CI Success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async moveUpAttr(id) {
      let currentIndex = this.currentSelectedCIChildren
        .map(i => i.ciTypeAttrId)
        .indexOf(id);
      if (!this.currentSelectedCIChildren[currentIndex - 1]) {
        this.$Notice.warning({
          title: "Warning",
          desc: "已经是第一个"
        });
        return;
      }
      let targetID = this.currentSelectedCIChildren[currentIndex - 1]
        .ciTypeAttrId;
      let res = await swapCiTypeAttributePosition(
        this.currentSelectedCI.ciTypeId,
        id,
        targetID
      );
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Move up CI attr Success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async moveDownAttr(id) {
      let currentIndex = this.currentSelectedCIChildren
        .map(i => i.ciTypeAttrId)
        .indexOf(id);
      if (!this.currentSelectedCIChildren[currentIndex + 1]) {
        this.$Notice.warning({
          title: "Warning",
          desc: "已经是最后一个"
        });
        return;
      }
      let targetID = this.currentSelectedCIChildren[currentIndex + 1]
        .ciTypeAttrId;
      let res = await swapCiTypeAttributePosition(
        this.currentSelectedCI.ciTypeId,
        id,
        targetID
      );
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Move Down CI attr Success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async addNewAttr(id) {
      const payload = {
        ...this.addNewAttrForm,
        length: this.addNewAttrForm.length || 1,
        isRefreshable: this.addNewAttrForm.isRefreshable === "yes",
        isDisplayed: this.addNewAttrForm.isDisplayed === "yes",
        isAccessControlled: this.addNewAttrForm.isAccessControlled === "yes",
        isNullable: this.addNewAttrForm.isNullable === "yes",
        isAuto: this.addNewAttrForm.isAuto === "yes",
        isEditable: this.addNewAttrForm.isEditable === "yes",
        callbackId: "10000001"
      };
      let res = await createNewCIAttr(this.currentSelectedCI.ciTypeId, payload);
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Add New CI Attr Success",
          desc: res.message
        });
        this.resetAddAttrForm();
        this.isAddNewAttrModalVisible = false;
        this.initGraph();
      }
    },
    addNewAttrHandler() {
      this.getEnum(true);
      this.isAddNewAttrModalVisible = true;
    },
    resetAddAttrForm() {
      this.addNewAttrForm = {};
    },
    async saveAttr(ciTypeAttrId, form) {
      let payload = {
        ...form,
        length: form.length || 1,
        isRefreshable: form.isRefreshable === "yes",
        isDisplayed: form.isDisplayed === "yes",
        isAccessControlled:
          form.inputType === "text" && form.isAccessControlled === "yes",
        isNullable: form.isNullable === "yes",
        isAuto: form.isAuto === "yes",
        isEditable: form.isEditable === "yes"
      };
      delete payload.status;
      delete payload.ciType;
      let res = await updateCIAttr(
        this.currentSelectedCI.ciTypeId,
        ciTypeAttrId,
        payload
      );
      if (res.status === "OK") {
        this.$Notice.success({
          title: "Save CI Attr Success",
          desc: res.message
        });
        this.initGraph();
      }
    },
    async applyAttr(ciTypeAttrId, form) {
      let updateRes = await updateCIAttr(
        this.currentSelectedCI.ciTypeId,
        ciTypeAttrId,
        {
          ...form,
          length: form.length || 1,
          isRefreshable: form.isRefreshable === "yes",
          isDisplayed: form.isDisplayed === "yes",
          isAccessControlled:
            form.inputType === "text" && form.isAccessControlled === "yes",
          isNullable: form.isNullable === "yes",
          isAuto: form.isAuto === "yes",
          isEditable: form.isEditable === "yes"
        }
      );
      if (updateRes.status === "OK") {
        let applyRes = await applyCIAttr(this.currentSelectedCI.ciTypeId, [
          ciTypeAttrId
        ]);
        if (applyRes.status === "OK") {
          this.$Notice.success({
            title: "Apply CI Attr Success",
            desc: applyRes.message
          });
          this.initGraph();
        }
      }
    },

    handleNewCITypeUploadImgSuccess(res, file) {
      if (res.statusCode === "OK") {
        this.$Notice.success({
          title: "Icon upload successful",
          desc: res.message
        });

        this.addNewCITypeForm.imageFileId = res.data.id;
      } else {
        this.$Notice.warning({
          title: "Icon upload failed",
          desc: res.message
        });
      }
    },
    handleUploadImgSuccess(res, file) {
      if (res.statusCode === "OK") {
        this.$Notice.success({
          title: "Icon upload successful",
          desc: res.message
        });
        this.initGraph(this.selectedStatus);
      } else {
        this.$Notice.warning({
          title: "Icon upload failed",
          desc: res.message
        });
      }
    },
    handleFormatError(file) {
      this.$Notice.warning({
        title: "The file format is incorrect",
        desc:
          "File format of " + file.name + " is incorrect, please select png."
      });
    },
    handleMaxSize(file) {
      this.$Notice.warning({
        title: "Exceeding file size limit",
        desc: "File  " + file.name + " is too large, no more than 100kb."
      });
    },
    async getAllCITypesList() {
      const res = await getAllCITypes();
      if (res.status === "OK") {
        this.allCiTypes = res.data;
      }
    },
    async getAllInputTypesList() {
      const res = await getAllInputTypes();
      if (res.status === "OK") {
        this.allInputTypes = res.data;
      }
    },
    async getAllReferenceTypesList() {
      const payload = {
        filters: [
          { name: "cat.catName", operator: "eq", value: "ci_attr_ref_type" }
        ],
        paging: false
      };
      const res = await getAllSystemEnumCodes(payload);
      if (res.status === "OK") {
        this.allReferenceTypes = res.data.contents;
      }
    },
    async getTableStatusList() {
      const res = await getTableStatus();
      if (res.status === "OK") {
        this.statusList = res.data;
      }
    }
  },
  mounted() {
    this.initGraph();
    this.getAllCITypesList();
    this.getAllInputTypesList();
    this.getAllReferenceTypesList();
    this.getTableStatusList();
  },
  computed: {
    setUploadActionHeader() {
      let uploadToken = document.cookie
        .split(";")
        .find(i => i.indexOf("XSRF-TOKEN") !== -1);
      return {
        "X-XSRF-TOKEN": uploadToken && uploadToken.split("=")[1]
      };
    }
  }
};
</script>

<style lang="scss" scoped>
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
.func-wrapper {
  .header-buttons-container {
    float: right;
  }
}
</style>
