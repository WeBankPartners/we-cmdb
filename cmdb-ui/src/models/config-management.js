import produce from "immer";

const configManagement = {
  name: "configManagement",
  state: {
    activedCI: {},
    selectedCatalog: {},
    ciTypeAttributes: {
      attributes: []
    },
    unionGroup: []
  },
  reducers: {
    _setActivedCI: produce((state, catalog) => {
      state.activedCI = catalog;
    }),
    _setSelectedCatalog: produce((state, catalog) => {
      state.selectedCatalog = catalog;
    }),
    _setCIAttributes: produce((state, attrs) => {
      state.ciTypeAttributes = attrs;
    }),
    _setUnionGroup: produce((state, group) => {
      state.unionGroup = group;
    })
  },

  effects: {
    setActivedCI(catalog) {
      this._setActivedCI(catalog);
    },
    setSelectedCatalog(catalog) {
      this._setSelectedCatalog(catalog);
    },
    setCIAttributes(attrs) {
      this._setCIAttributes(attrs);
    },
    setUnionGroup(group) {
      this._setUnionGroup(group);
    }
  }
};

export default configManagement;
