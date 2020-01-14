<template>
  <div>
    <Table :data="data" :columns="columns" :loading="loading" @on-row-click="onRowClick"></Table>
    <Page
      :current="page.currentPage"
      :page-size="page.pageSize"
      :page-size-opts="pageSizeOptions"
      :total="page.total"
      @on-change="onChange"
      @on-page-size-change="onPageSizeChange"
      show-elevator
      show-sizer
      show-total
      style="float: right; margin: 10px 0;"
    />
  </div>
</template>

<script>
export default {
  props: {
    data: Array,
    columns: Array,
    page: {
      type: Object,
      default: () => {
        return {
          currentPage: 1,
          pageSize: 5,
          total: 0
        }
      }
    },
    pageSizeOptions: {
      type: Array,
      default: () => {
        return [5, 10, 20]
      }
    },
    loading: {
      default: false,
      required: false
    }
  },
  methods: {
    onChange (currentPage) {
      this.$emit('pageChange', currentPage)
    },
    onPageSizeChange (pageSize) {
      this.$emit('pageSizeChange', pageSize)
    },
    onRowClick (row) {
      this.$emit('rowClick', row)
    }
  }
}
</script>

<style lang="scss" scoped></style>
