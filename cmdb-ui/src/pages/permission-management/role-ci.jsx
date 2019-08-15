import React, { useState, useEffect } from "react";
import { withStyles } from "@material-ui/core/styles";
import CMDBTable from "../../components/cmdb-table";
import CMDBDialog from "../../components/cmdb-dialog";
import CMDBMessage from "../../components/cmdb-message";
import {
  Table,
  TableHead,
  TableBody,
  TableRow,
  TableCell,
  Checkbox
} from "@material-ui/core";
import {
  fetchAllCiTypes,
  retrieveRoles,
  retrieveRoleCiTypes,
  createRoleCiTypes,
  updateRoleCiTypes
} from "../../apis/endpoints";

const styles = theme => ({
  root: {
    padding: "10 0"
  },
  table: {
    tableLayout: "fixed"
  },
  head: {
    backgroundColor: "#e0e0e0",
    borderRight: "1px solid gray",
    borderBottom: "1px solid gray",
    borderTop: "1px solid gray",
    "&:last-child": {
      borderRight: "none"
    }
  },
  body: {
    fontSize: 14
  },
  row: {
    "&:nth-of-type(even)": {
      backgroundColor: theme.palette.background.default
    }
  },
  rowCell: {}
});

function RoleCi(props) {
  const { classes, columns } = props;

  const [allCiTypes, setAllCiTypes] = useState([]);
  const [tableData, setTableData] = useState([]);
  const [ciTableData, setCiTableData] = useState([]);
  const [visible, toggleVisible] = useState(false);
  const tableActions = [
    {
      name: "权限编辑",
      handler: row => showDialog(row),
      size: 100
    }
  ];
  const ciColumns = [
    {
      dataIndex: "name",
      cellType: "text",
      order: "asc",
      title: "名称"
    },
    {
      dataIndex: "creationPermission",
      cellType: "checkbox",
      order: "asc",
      title: "增"
    },
    {
      dataIndex: "removalPermission",
      cellType: "checkbox",
      order: "asc",
      title: "删"
    },
    {
      dataIndex: "modificationPermission",
      cellType: "checkbox",
      order: "asc",
      title: "改"
    },
    {
      dataIndex: "enquiryPermission",
      cellType: "checkbox",
      order: "asc",
      title: "查"
    },
    {
      dataIndex: "executionPermission",
      cellType: "checkbox",
      order: "asc",
      title: "执"
    }
  ];

  useEffect(() => {
    const fetchData = async () => {
      const [cis, rolesData] = await Promise.all([
        fetchAllCiTypes(),
        retrieveRoles({})
      ]);
      setAllCiTypes(cis);
      setTableData(rolesData.contents);
    };
    fetchData();
  }, []);

  const showDialog = async row => {
    const { contents: data } = await retrieveRoleCiTypes({
      filters: [
        {
          name: "roleId",
          operator: "eq",
          value: row.roleId
        }
      ]
    });
    if (data instanceof Array) {
      toggleVisible(true);
      let ciTypeObj = {};
      data.forEach(_ => {
        _.ciTypeId && (ciTypeObj[_.ciTypeId] = _);
      });
      const cis = allCiTypes.map((_, index) => {
        if (ciTypeObj[_.ciTypeId]) {
          return {
            index,
            ...ciTypeObj[_.ciTypeId],
            ..._
          };
        } else {
          return {
            index,
            ..._,
            roleId: row.roleId,
            creationPermission: "N",
            enquiryPermission: "N",
            executionPermission: "N",
            grantPermission: "N",
            modificationPermission: "N",
            removalPermission: "N"
          };
        }
      });
      setCiTableData(cis);
    }
  };

  const closeDialog = () => {
    toggleVisible(false);
  };

  const handleChange = (row, col) => async event => {
    let obj = {};
    ciTableData.find(_ => {
      if (row.index === _.index) {
        obj = {
          ciTypeId: _.ciTypeId,
          ciTypeName: _.ciTypeName,
          roleId: _.roleId,
          roleCiTypeId: _.roleCiTypeId ? _.roleCiTypeId : null,
          creationPermission: _.creationPermission,
          enquiryPermission: _.enquiryPermission,
          executionPermission: _.executionPermission,
          grantPermission: _.grantPermission,
          modificationPermission: _.modificationPermission,
          removalPermission: _.removalPermission
        };
        obj[col.dataIndex] = event.target.checked ? "Y" : "N";
      }
      return row.index === _.index;
    });

    const updatePermission = data => {
      if (data instanceof Array) {
        const val = ciTableData.map(_ => {
          if (row.index === _.index) {
            _[col.dataIndex] = obj[col.dataIndex];
            _.roleCiTypeId = data[0].roleCiTypeId;
          }
          return _;
        });
        setCiTableData(val);
        CMDBMessage({
          message: "权限更新成功"
        });
      }
    };

    if (obj.roleCiTypeId) {
      const result = await updateRoleCiTypes([obj]);
      updatePermission(result);
    } else {
      const result = await createRoleCiTypes([obj]);
      updatePermission(result);
    }
  };

  return (
    <div className={classes.root}>
      <CMDBTable
        select={false}
        columns={columns}
        source={tableData}
        actions={tableActions}
        hasPagination={false}
      />
      <CMDBDialog visible={visible} title="数据权限管理" onCancel={closeDialog}>
        <Table className={classes.table}>
          <TableHead>
            <TableRow>
              {ciColumns.map((col, i) => (
                <TableCell
                  className={classes.head}
                  align="center"
                  padding="none"
                  width={col.width}
                  key={i}
                >
                  {col.title}
                </TableCell>
              ))}
            </TableRow>
          </TableHead>
          <TableBody>
            {ciTableData.map((row, rowIndex) => (
              <TableRow className={classes.row} key={`row${rowIndex}`}>
                {ciColumns.map((col, colIndex) => (
                  <TableCell
                    padding="none"
                    width={60}
                    align="center"
                    key={`${rowIndex}-${colIndex}`}
                  >
                    {col.cellType === "text" && (
                      <span>{row[col.dataIndex]}</span>
                    )}
                    {col.cellType === "checkbox" && (
                      <Checkbox
                        checked={row[col.dataIndex] === "Y"}
                        color="primary"
                        onChange={handleChange(row, col)}
                      />
                    )}
                  </TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </CMDBDialog>
    </div>
  );
}

export default withStyles(styles)(RoleCi);
