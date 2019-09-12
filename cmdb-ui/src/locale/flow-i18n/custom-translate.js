import CNtranslations from "./cn-translations";

export default function customTranslate(template, replacements) {
  replacements = replacements || {};

  // Translate
  template = CNtranslations[template] || template;

  // Replace
  return template.replace(/{([^}]+)}/g, function(_, key) {
    return replacements[key] || "{" + key + "}";
  });
}
