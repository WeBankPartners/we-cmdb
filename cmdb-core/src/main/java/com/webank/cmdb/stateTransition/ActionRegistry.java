package com.webank.cmdb.stateTransition;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class ActionRegistry {
    private static ActionRegistry instance = new ActionRegistry();
    private Map<String, Action> actions = new ConcurrentHashMap<>();

    public static ActionRegistry getInstance() {
        return instance;
    }

    public void register(Action action) {
        actions.put(action.getName(), action);
    }

    public Action getAction(String name) {
        return actions.get(name);
    }
}
