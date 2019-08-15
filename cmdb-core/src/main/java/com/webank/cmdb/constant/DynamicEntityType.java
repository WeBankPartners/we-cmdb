package com.webank.cmdb.constant;

public enum DynamicEntityType {
    CI, // Normal dynamic entity for CI data
    MultiSelection, // Intermediate entity for multiple selection
    MultiReference, // Intermediate entity for multiple reference
    MultiSelIntermedia, MultiRefIntermedia;
}
