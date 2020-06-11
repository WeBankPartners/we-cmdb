package com.webank.cmdb.util;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.google.common.base.Strings;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.support.exception.AttributeNotFoundException;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.impl.StaticEntityRepositoryImpl.FilterPath;
import com.webank.cmdb.repository.impl.StaticEntityRepositoryImpl.JoinFilter;

public class QueryConverter {
    public static QueryRequest convertToDomainQuery(QueryRequest dtoQueryRequest, Map<String, String> dtoToDomainFieldMap) {
        dtoQueryRequest.getFilters().forEach(x -> {
            String domainField = dtoToDomainFieldMap.get(x.getName());
            if (Strings.isNullOrEmpty(domainField)) {
                x.setName(x.getName());
            } else {
                x.setName(domainField);
            }
        });

        String sortingField = dtoQueryRequest.getSorting().getField();
        if (!Strings.isNullOrEmpty(sortingField)) {
            String sortDomainField = dtoToDomainFieldMap.get(sortingField);
            if (Strings.isNullOrEmpty(sortDomainField)) {
                throw new AttributeNotFoundException(String.format("Can not find domain field for %s.", sortDomainField));
            }
            dtoQueryRequest.getSorting().setField(sortDomainField);
        }

        return dtoQueryRequest;
    }

    /*
     * public static Class<?> getDtoFieldClass(Class dtoClzz, String fieldName){
     * Field[] fields = dtoClzz.getDeclaredFields(); for(Field field:fields) {
     * String dtoFieldName = field.getName(); if(dtoFieldName.equals(fieldName)) {
     * Class fieldClzz = field.getType();
     * if(fieldClzz.isAssignableFrom(Collection.class)) { ParameterizedTypeImpl
     * genType = (ParameterizedTypeImpl)field.getGenericType(); Type argType =
     * genType.getActualTypeArguments()[0]; if(argType instanceof WildcardTypeImpl)
     * return null; }else { return fieldClzz; } } } return null; }
     */

    public static <T extends ResourceDto> FilterPath convertFilter(Class<T> dtoClazz, List<String> refResources, List<Filter> filters) {
        Map<String, List<Filter>> filterMap = new TreeMap<>();
        filters.forEach(x -> {
            String name = x.getName();
            String attrName;
            String path;
            int index = name.lastIndexOf(".");
            if (index == -1) {
                attrName = name;
                path = ".";
            } else {
                attrName = name.substring(index + 1);
                path = name.substring(0, index);
            }

            List<Filter> fs = filterMap.get(path);
            if (fs == null) {
                fs = new LinkedList<>();
            }
            // update filter name to be attribute name
            Filter attrFilter = new Filter(attrName, x.getOperator(), x.getValue());
            fs.add(attrFilter);
            filterMap.put(path, fs);
        });

        DtoNode rootNode = new DtoNode(".", dtoClazz, filterMap.get("."));

        filterMap.forEach((k, v) -> {
            List<String> nodeHierachy = new LinkedList<>();
            if (k.indexOf(".") == -1) {
                nodeHierachy.add(k);
            } else {
                String[] resHierachy = k.split("\\.");
                nodeHierachy = CollectionUtils.asLinkedList(resHierachy);
            }
            DtoNode curNode = getNode(rootNode, nodeHierachy, v);
        });

        FilterPath rootFilterPath = convertDtoFilterTree(rootNode, null);
        return rootFilterPath;
    }

    private static FilterPath convertDtoFilterTree(DtoNode dtoNode, Map<String, String> parentDtoToDomainFieldMap) {
        FilterPath filterPath = new FilterPath();
        if (parentDtoToDomainFieldMap != null) {
            filterPath.setJoinAttr(parentDtoToDomainFieldMap.get(dtoNode.getName()));
        } else {
            filterPath.setJoinAttr(dtoNode.getName());
        }
        List<JoinFilter> joinFilters = new LinkedList<>();
        dtoNode.getFilters().forEach(x -> {
            joinFilters.add(new JoinFilter(dtoNode.getDtoToDomainFieldMap().get(x.getName()), FilterOperator.fromCode(x.getOperator()), x.getValue()));
        });

        filterPath.setFilters(joinFilters);

        for (DtoNode node : dtoNode.getChildrenNodes()) {
            filterPath.getJoinChildren().add(convertDtoFilterTree(node, dtoNode.getDtoToDomainFieldMap()));
        }
        return filterPath;
    }

    private static DtoNode getNode(DtoNode parentNode, List<String> nodeHierachy, List<Filter> filters) {
        if (nodeHierachy == null || nodeHierachy.size() == 0)
            return null;

        String curRes = nodeHierachy.get(0);
        nodeHierachy.remove(0);

        DtoNode curNode = null;
        for (DtoNode node : parentNode.getChildrenNodes()) {
            if (curRes.equals(node.getName())) {
                curNode = node;
            }
        }

        if (curNode == null) {
            Class dtoClass = parentNode.getRefResourceClass(curRes);
            if (dtoClass == null) {
                throw new InvalidArgumentException(String.format("Can not find out resource [%s] in dto class [%s]", curRes, parentNode.getDtoClass().toString()));
            }
            curNode = new DtoNode(curRes, dtoClass);
            parentNode.getChildrenNodes().add(curNode);
        }
        if (nodeHierachy.size() == 0) {
            curNode.getFilters().addAll(filters);
            return curNode;
        } else {
            return getNode(curNode, nodeHierachy, filters);
        }
    }

    static class DtoNode {
        private String name;
        private List<Filter> filters = new LinkedList<>();
        private List<DtoNode> childrenNodes = new LinkedList<>();
        private Class dtoClass;
        private Map<String, Class<?>> refResourceMap;
        private Map<String, String> dtoToDomainFieldMap;

        public DtoNode(String name, Class dtoClass) {
            this(name, dtoClass, null);
        }

        public DtoNode(String name, Class dtoClass, List<Filter> filters) {
            this.name = name;
            this.dtoClass = dtoClass;
            if (filters != null) {
                this.filters.addAll(filters);
            }
            this.refResourceMap = ClassUtils.getAllDtoRefResources(dtoClass);
            this.dtoToDomainFieldMap = ClassUtils.getDtoToDomainFieldMap(dtoClass);
        }

        public Class getRefResourceClass(String refResName) {
            return refResourceMap.get(refResName);
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public List<DtoNode> getChildrenNodes() {
            return childrenNodes;
        }

        public void setChildrenNodes(List<DtoNode> childrenNodes) {
            this.childrenNodes = childrenNodes;
        }

        public List<Filter> getFilters() {
            return filters;
        }

        public void setFilters(List<Filter> filters) {
            this.filters = filters;
        }

        public Class getDtoClass() {
            return dtoClass;
        }

        public void setDtoClass(Class dtoClass) {
            this.dtoClass = dtoClass;
        }

        public Map<String, String> getDtoToDomainFieldMap() {
            return dtoToDomainFieldMap;
        }
    }
}
