package com.webank.cmdb.dynamicEntity;

import java.sql.Timestamp;
import java.util.Collection;
import java.util.Map;

import javax.persistence.CascadeType;

import org.objectweb.asm.AnnotationVisitor;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;

import com.google.common.base.Strings;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.constant.DynamicEntityType;
import com.webank.cmdb.constant.EntityRelationship;

public class DynamicEntityGenerator implements Opcodes {
    private static Map<Class<?>, String> typeMap = ImmutableMap.of(Integer.class, "Ljava/lang/Integer;", String.class, "Ljava/lang/String;", java.util.Date.class, "Ljava/sql/Timestamp;", Timestamp.class, "Ljava/sql/Timestamp;");

    /**
     * Generate class byte code for given CI information
     * 
     * @param quanlifiedClass class name include package
     * @param tableName       table name of the given CI
     * @param fields          Fields of the domain object
     * @return
     */
    public static byte[] generate(String quanlifiedClass, String tableName, Collection<FieldNode> fields) {
        String classDesc = quanlifiedClass.replace('.', '/');
        String className = classDesc.substring(classDesc.lastIndexOf('/') + 1);

        ClassWriter classWriter = new ClassWriter(0);
        FieldVisitor fieldVisitor;
        writeClass(classDesc, tableName, className, classWriter);

        {
            fieldVisitor = classWriter.visitField(ACC_PRIVATE | ACC_FINAL | ACC_STATIC, "serialVersionUID", "J", null, new Long(1L));
            fieldVisitor.visitEnd();
        }

        fields.forEach(x -> {
            writeField(classWriter, x);
        });

        writeConstructor(classWriter);

        fields.forEach(x -> {
            writeGetter(classWriter, x, classDesc);
            writeSetter(classWriter, x, classDesc);
        });
        classWriter.visitEnd();

        return classWriter.toByteArray();
    }

    private static void writeClass(String classDesc, String tabelName, String className, ClassWriter classWriter) {
        AnnotationVisitor annotationVisitor0;
        classWriter.visit(V1_8, ACC_PUBLIC | ACC_SUPER, classDesc, null, "java/lang/Object", new String[] { "java/io/Serializable" });

        annotationVisitor0 = classWriter.visitAnnotation("Ljavax/persistence/Entity;", true);
        annotationVisitor0.visitEnd();

        annotationVisitor0 = classWriter.visitAnnotation("Ljavax/persistence/Table;", true);
        annotationVisitor0.visit("name", tabelName);
        annotationVisitor0.visitEnd();

        annotationVisitor0 = classWriter.visitAnnotation("Ljavax/persistence/NamedQuery;", true);
        annotationVisitor0.visit("name", className + ".findAll");
        annotationVisitor0.visit("query", "SELECT a FROM " + className + " a");
        annotationVisitor0.visitEnd();
    }

    private static void writeConstructor(ClassWriter classWriter) {
        MethodVisitor methodVisitor;
        methodVisitor = classWriter.visitMethod(ACC_PUBLIC, "<init>", "()V", null, null);
        methodVisitor.visitVarInsn(ALOAD, 0);
        methodVisitor.visitMethodInsn(INVOKESPECIAL, "java/lang/Object", "<init>", "()V", false);
        methodVisitor.visitInsn(RETURN);
        methodVisitor.visitMaxs(1, 1);
        methodVisitor.visitEnd();
    }

    private static void writeField(ClassWriter classWriter, FieldNode field) {
        FieldVisitor fieldVisitor;
        if (field.isJoinNode()) {
            if (EntityRelationship.ManyToOne.equals(field.getEntityRelationship())) {
                fieldVisitor = classWriter.visitField(ACC_PRIVATE, field.getName(), field.getTypeDesc(), null, null);
            } else { // OneToMany or ManyToMany
                fieldVisitor = classWriter.visitField(ACC_PRIVATE, field.getName(), "Ljava/util/Set;", getTypeSiganitureForOneToMany(field.getTypeDesc()), null);
            }
            // ignore join field for json
            AnnotationVisitor annotationVisitor0 = fieldVisitor.visitAnnotation("Lcom/fasterxml/jackson/annotation/JsonIgnore;", true);
            annotationVisitor0.visitEnd();
        } else {
            fieldVisitor = classWriter.visitField(ACC_PRIVATE, field.getName(), typeMap.get(field.getType()), null, null);
        }
        fieldVisitor.visitEnd();
    }

    private static String getTypeSiganitureForOneToMany(String desc) {
        return "Ljava/util/Set<" + desc + ">;";
    }

    private static void writeGetter(ClassWriter classWriter, FieldNode field, String className) {
        MethodVisitor methodVisitor;
        AnnotationVisitor annotationVisitor0;

        String getter = "get" + Character.toUpperCase(field.getName().charAt(0)) + field.getName().substring(1);
        if (!field.isJoinNode()) {
            String setterDesc = "()" + typeMap.get(field.getType());
            methodVisitor = classWriter.visitMethod(ACC_PUBLIC, getter, setterDesc, null, null);
            if (field.isId()) {
                {
                    annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/Id;", true);
                    annotationVisitor0.visitEnd();
                    if (DynamicEntityType.MultiSelIntermedia.equals(field.getEntityType())) {
                        annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/GeneratedValue;", true);
                        annotationVisitor0.visitEnd();
                    }
                }
            }

            annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/Column;", true);
            annotationVisitor0.visit("name", field.getColumn());
            annotationVisitor0.visitEnd();

            // getter method body
            methodVisitor.visitVarInsn(ALOAD, 0);
            methodVisitor.visitFieldInsn(GETFIELD, className, field.getName(), typeMap.get(field.getType()));
            methodVisitor.visitInsn(ARETURN);
            methodVisitor.visitMaxs(1, 1);
            methodVisitor.visitEnd();

        } else if (EntityRelationship.ManyToOne.equals(field.getEntityRelationship())) {

            String getterDesc = "()" + field.getTypeDesc();
            methodVisitor = classWriter.visitMethod(ACC_PUBLIC, getter, getterDesc, null, null);

            annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/ManyToOne;", true);
            annotationVisitor0.visitEnum("fetch", "Ljavax/persistence/FetchType;", "LAZY");
            annotationVisitor0.visitEnd();

            annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/JoinColumn;", true);
            annotationVisitor0.visit("name", field.getColumn());
            // if(!DynamicEntityType.MultiSelIntermedia.equals(field.getEntityType()))

            annotationVisitor0.visit("insertable", Boolean.FALSE);
            annotationVisitor0.visit("updatable", Boolean.FALSE);

            annotationVisitor0.visitEnd();

            annotationVisitor0 = methodVisitor.visitAnnotation("Lcom/fasterxml/jackson/annotation/JsonIgnore;", true);
            annotationVisitor0.visitEnd();

            // getter method body
            methodVisitor.visitVarInsn(ALOAD, 0);
            methodVisitor.visitFieldInsn(GETFIELD, className, field.getName(), field.getTypeDesc());
            methodVisitor.visitInsn(ARETURN);
            methodVisitor.visitMaxs(1, 1);
            methodVisitor.visitEnd();

        } else if (EntityRelationship.OneToMany.equals(field.getEntityRelationship())) {// OneToMany

            writeGetterForMapperBy(classWriter, field, className, getter);
        } else if (EntityRelationship.ManyToMany.equals(field.getEntityRelationship())) {
            String mapperBy = field.getMappedBy();
            if (Strings.isNullOrEmpty(mapperBy)) {
                String getterDesc = "()" + field.getTypeDesc();
                methodVisitor = classWriter.visitMethod(ACC_PUBLIC, getter, "()Ljava/util/Set;", "()" + getTypeSiganitureForOneToMany(field.getTypeDesc()), null);

                {
                    annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/ManyToMany;", true);
                    annotationVisitor0.visitEnum("fetch", "Ljavax/persistence/FetchType;", "LAZY");
                    {
                        AnnotationVisitor annotationVisitor1 = annotationVisitor0.visitArray("cascade");
                        annotationVisitor1.visitEnum(null, "Ljavax/persistence/CascadeType;", CascadeType.PERSIST.toString());
                        annotationVisitor1.visitEnum(null, "Ljavax/persistence/CascadeType;", CascadeType.MERGE.toString());
                        annotationVisitor1.visitEnum(null, "Ljavax/persistence/CascadeType;", CascadeType.REFRESH.toString());
                        annotationVisitor1.visitEnum(null, "Ljavax/persistence/CascadeType;", CascadeType.DETACH.toString());
                        annotationVisitor1.visitEnd();
                    }
                    annotationVisitor0.visitEnd();
                }
                {
                    annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/JoinTable;", true);
                    annotationVisitor0.visit("name", field.getJoinTable());
                    {
                        AnnotationVisitor annotationVisitor1 = annotationVisitor0.visitArray("joinColumns");
                        {
                            AnnotationVisitor annotationVisitor2 = annotationVisitor1.visitAnnotation(null, "Ljavax/persistence/JoinColumn;");
                            annotationVisitor2.visit("name", "from_guid");
                            annotationVisitor2.visit("referencedColumnName", "guid");
                            annotationVisitor2.visitEnd();
                        }
                        annotationVisitor1.visitEnd();
                    }
                    {
                        AnnotationVisitor annotationVisitor1 = annotationVisitor0.visitArray("inverseJoinColumns");
                        {
                            AnnotationVisitor annotationVisitor2 = annotationVisitor1.visitAnnotation(null, "Ljavax/persistence/JoinColumn;");
                            if (DynamicEntityType.MultiReference.equals(field.getEntityType())) {
                                annotationVisitor2.visit("name", "to_guid");
                                annotationVisitor2.visit("referencedColumnName", "guid");
                            }
                            /*
                             * else {//muti selection annotationVisitor2.visit("name", "to_code");
                             * annotationVisitor2.visit("referencedColumnName", "adm_basekey_code"); }
                             */
                            annotationVisitor2.visitEnd();
                        }
                        annotationVisitor1.visitEnd();
                    }
                    annotationVisitor0.visitEnd();
                }

                {
                    annotationVisitor0 = methodVisitor.visitAnnotation("Lcom/fasterxml/jackson/annotation/JsonIgnore;", true);
                    annotationVisitor0.visitEnd();
                }

                // getter method body
                methodVisitor.visitVarInsn(ALOAD, 0);
                methodVisitor.visitFieldInsn(GETFIELD, className, field.getName(), "Ljava/util/Set;");
                methodVisitor.visitInsn(ARETURN);
                methodVisitor.visitMaxs(1, 1);
                methodVisitor.visitEnd();

            } else {// mapper by
                writeGetterForMapperBy(classWriter, field, className, getter);
            }
        }
    }

    private static void writeGetterForMapperBy(ClassWriter classWriter, FieldNode field, String className, String getter) {
        MethodVisitor methodVisitor;
        AnnotationVisitor annotationVisitor0;
        methodVisitor = classWriter.visitMethod(ACC_PUBLIC, getter, "()Ljava/util/Set;", "()" + getTypeSiganitureForOneToMany(field.getTypeDesc()), null);
        if (DynamicEntityType.MultiReference.equals(field.getEntityType())) {
            annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/ManyToMany;", true);
            annotationVisitor0.visit("mappedBy", field.getMappedBy());
            annotationVisitor0.visitEnd();
        } else {
            annotationVisitor0 = methodVisitor.visitAnnotation("Ljavax/persistence/OneToMany;", true);
            annotationVisitor0.visit("mappedBy", field.getMappedBy());
            if (DynamicEntityType.MultiSelection.equals(field.getEntityType())) {
                annotationVisitor0.visitEnum("fetch", "Ljavax/persistence/FetchType;", "LAZY");
                AnnotationVisitor annotationVisitor1 = annotationVisitor0.visitArray("cascade");
                annotationVisitor1.visitEnum(null, "Ljavax/persistence/CascadeType;", CascadeType.ALL.toString());
                annotationVisitor1.visitEnd();
            }
            annotationVisitor0.visitEnd();
        }
        {
            annotationVisitor0 = methodVisitor.visitAnnotation("Lcom/fasterxml/jackson/annotation/JsonIgnore;", true);
            annotationVisitor0.visitEnd();
        }

        // getter method body
        methodVisitor.visitVarInsn(ALOAD, 0);
        methodVisitor.visitFieldInsn(GETFIELD, className, field.getName(), "Ljava/util/Set;");
        methodVisitor.visitInsn(ARETURN);
        methodVisitor.visitMaxs(1, 1);
        methodVisitor.visitEnd();
    }

    private static void writeSetter(ClassWriter classWriter, FieldNode field, String className) {
        MethodVisitor methodVisitor;

        String setter = "set" + Character.toUpperCase(field.getName().charAt(0)) + field.getName().substring(1);
        if (!field.isJoinNode()) {
            // setter
            String paramDesc = "(" + typeMap.get(field.getType()) + ")V";
            {
                methodVisitor = classWriter.visitMethod(ACC_PUBLIC, setter, paramDesc, null, null);
                methodVisitor.visitParameter(field.getName(), 0);
                methodVisitor.visitVarInsn(ALOAD, 0);
                methodVisitor.visitVarInsn(ALOAD, 1);
                methodVisitor.visitFieldInsn(PUTFIELD, className, field.getName(), typeMap.get(field.getType()));
                methodVisitor.visitInsn(RETURN);
                methodVisitor.visitMaxs(2, 2);
                methodVisitor.visitEnd();
            }

        } else if (EntityRelationship.ManyToOne.equals(field.getEntityRelationship())) {
            // setter
            String paramDesc = "(" + field.getTypeDesc() + ")V";
            {
                methodVisitor = classWriter.visitMethod(ACC_PUBLIC, setter, paramDesc, null, null);
                methodVisitor.visitParameter(field.getName(), 0);
                methodVisitor.visitVarInsn(ALOAD, 0);
                methodVisitor.visitVarInsn(ALOAD, 1);
                methodVisitor.visitFieldInsn(PUTFIELD, className, field.getName(), field.getTypeDesc());
                methodVisitor.visitInsn(RETURN);
                methodVisitor.visitMaxs(2, 2);
                methodVisitor.visitEnd();
            }
        } else if (EntityRelationship.OneToMany.equals(field.getEntityRelationship()) || EntityRelationship.ManyToMany.equals(field.getEntityRelationship())) {// OneToMany
            // setter
            String paramDesc = "(" + field.getTypeDesc() + ")V";
            {
                methodVisitor = classWriter.visitMethod(ACC_PUBLIC, setter, "(Ljava/util/Set;)V", "(" + getTypeSiganitureForOneToMany(field.getTypeDesc()) + ")V", null);
                methodVisitor.visitParameter(field.getName(), 0);
                methodVisitor.visitVarInsn(ALOAD, 0);
                methodVisitor.visitVarInsn(ALOAD, 1);
                methodVisitor.visitFieldInsn(PUTFIELD, className, field.getName(), "Ljava/util/Set;");
                methodVisitor.visitInsn(RETURN);
                methodVisitor.visitMaxs(2, 2);
                methodVisitor.visitEnd();
            }

        }

    }

}
