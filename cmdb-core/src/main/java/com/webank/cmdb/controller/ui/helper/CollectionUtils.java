package com.webank.cmdb.controller.ui.helper;

import static java.util.function.Function.identity;
import static org.apache.commons.collections4.CollectionUtils.isEmpty;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

import com.webank.cmdb.support.exception.CmdbException;

public class CollectionUtils {

    public static <K, V> Map<K, V> asMap(Collection<V> list, Function<? super V, K> keyFunction) {
        if (list == null || list.isEmpty()) {
            return new HashMap<>();
        } else {
            return list.stream().collect(Collectors.toMap(keyFunction, identity(), (oldValue, newValue) -> oldValue));
        }
    }

    public static <K, E> List<E> getOrCreateArrayList(Map<K, List<E>> map, K key) {
        List<E> element = map.get(key);
        if (element == null) {
            element = new ArrayList<>();
            map.put(key, element);
        }
        return element;
    }

    public static <T, K, V> Map<K, V> getOrCreateHashMap(Map<T, Map<K, V>> map, T key) {
        Map<K, V> element = map.get(key);
        if (element == null) {
            element = new HashMap<>();
            map.put(key, element);
        }
        return element;
    }

    public static <K, V> void putToMap(Map<K, V> targetMap, List<V> addingList, Function<? super V, K> keyMapper) {
        for (V element : addingList) {
            targetMap.put(keyMapper.apply(element), element);
        }
    }

    public static <K, V> void putToSet(Set<K> targetMap, Collection<V> addingList, Function<? super V, K> keyMapper) {
        for (V element : addingList) {
            targetMap.add(keyMapper.apply(element));
        }
    }

    public static <G, E> List<G> groupUp(List<G> groups,
            List<E> elements,
            Function<? super G, Object> keyMapperOfGroup,
            Function<? super G, List<E>> childrenMapperOfGroup,
            Function<? super E, Object> parentMapperOfElement) {
        if (isEmpty(groups))
            return groups;
        if (isEmpty(elements))
            return groups;
        if (keyMapperOfGroup == null)
            throw new CmdbException("3069", "Key mapper of Group Object cannot be null for grouping function.");
        if (childrenMapperOfGroup == null)
            throw new CmdbException("3070", "Children mapper of Group Object cannot be null for grouping function.");
        if (parentMapperOfElement == null)
            throw new CmdbException("3071", "Parent mapper of Element Object cannot be null for grouping function.");
        List<G> resultGroups = new ArrayList<>(groups);
        Map<Object, G> groupMap = asMap(resultGroups, keyMapperOfGroup);

        elements.forEach(element -> {
            Object parentId = parentMapperOfElement.apply(element);
            if (parentId == null)
                return;
            G group = groupMap.get(parentId);
            if (group == null)
                return;
            List<E> children = childrenMapperOfGroup.apply(group);
            if (children == null)
                throw new CmdbException("3072", "Children property should not be null.");
            children.add(element);
        });
        return resultGroups;
    }

    public static <E> E pickRandomOne(List<E> collection) {
        if (isEmpty(collection))
            return null;
        return collection.get(new Random().nextInt(collection.size()));
    }

    public static <E> E pickLastOne(List<E> collection, Comparator<E> comparator) {
        if (isEmpty(collection))
            return null;
        if (comparator != null)
            collection.sort(comparator);
        return collection.get(collection.size() - 1);
    }
}
