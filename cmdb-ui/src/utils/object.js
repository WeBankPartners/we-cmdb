export const pick = (source, target) => {
  let t = {};
  Object.keys(target).forEach(key => (t[key] = source[key] || target[key]));
  return t;
};

export const uppercaseFirst = str => {
  return str.map(_ => _.replace(_[0], _[0].toUpperCase()));
};

export const genFilters = filters => {
  const temp = [];

  Object.keys(filters).reduce((acc, cur) => {
    if (filters[cur].operator === "range") {
      if (filters[cur].value[0]) {
        acc.push({
          name: cur,
          operator: "gt",
          value: filters[cur].value[0]
        });
      }
      if (filters[cur].value[1]) {
        acc.push({
          name: cur,
          operator: "lt",
          value: filters[cur].value[1]
        });
      }
    } else {
      acc.push(filters[cur]);
    }
    return acc;
  }, temp);

  return temp;
};

const indexCode = {
  select: "codeId",
  ref: "key_name"
};
export const genIndexCode = (defaultValue, inputType) => {
  return indexCode[inputType]
    ? `${defaultValue}.${indexCode[inputType]}`
    : defaultValue;
};

const indexValue = {
  select: "code",
  ref: "key_name"
};
export const genIndexValue = (defaultValue, inputType) => {
  return indexValue[inputType]
    ? `${defaultValue}.${indexValue[inputType]}`
    : defaultValue;
};

export const getValueByIndexCode = (source, dataIndex = "") => {
  const array = dataIndex.split(".");
  if (array.length === 1) {
    if (typeof source[dataIndex] === "boolean") {
      return source[dataIndex] ? 1 : 0;
    } else {
      return source[dataIndex];
    }
  }
  let result = source;
  for (let i = 0; i < array.length; i++) {
    if (!result[array[i]]) {
      return "";
    }
    result = result[array[i]];
  }
  return result;
};

export const getCookieByName = name => {
  const cookies = document.cookie.split(";");
  const t = {};
  cookies.forEach(c => {
    const [k, v] = c.split("=");
    t[k] = v;
  });

  return t[name];
};
