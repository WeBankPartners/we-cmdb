package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_files database table.
 * 
 */
//@Entity
@Table(name = "INFORMATION_SCHEMA.QUERY_STATISTICS")
@NamedQuery(name = "QueryStatistics.findAll", query = "SELECT a FROM QueryStatistics a")
public class QueryStatistics implements Serializable {
    private static final long serialVersionUID = 1L;
    private String sqlStatement;
    private Integer executionCount;
    private Double minExecutionTime;
    private Double maxExecutionTime;
    private Double cumulativeExecutionTime;
    private Double averageExecutionTime;
    private Double stdDevExecutionTime;
    private Integer minRowCount;
    private Integer maxRowCount;
    private Integer cumulativeRowCount;
    private Double averageRowCount;
    private Double stdDevRowCount;

    public QueryStatistics() {
    }

    @Column(name = "sql_statement")
    public String getSqlStatement() {
        return sqlStatement;
    }

    public void setSqlStatement(String sqlStatement) {
        this.sqlStatement = sqlStatement;
    }

    @Column(name = "execution_count")
    public Integer getExecutionCount() {
        return executionCount;
    }

    public void setExecutionCount(Integer executionCount) {
        this.executionCount = executionCount;
    }

    @Column(name = "min_execution_time")
    public Double getMinExecutionTime() {
        return minExecutionTime;
    }

    public void setMinExecutionTime(Double minExecutionTime) {
        this.minExecutionTime = minExecutionTime;
    }

    @Column(name = "max_execution_time")
    public Double getMaxExecutionTime() {
        return maxExecutionTime;
    }

    public void setMaxExecutionTime(Double maxExecutionTime) {
        this.maxExecutionTime = maxExecutionTime;
    }

    @Column(name = "cumulative_execution_time")
    public Double getCumulativeExecutionTime() {
        return cumulativeExecutionTime;
    }

    public void setCumulativeExecutionTime(Double cumulativeExecutionTime) {
        this.cumulativeExecutionTime = cumulativeExecutionTime;
    }

    @Column(name = "average_execution_time")
    public Double getAverageExecutionTime() {
        return averageExecutionTime;
    }

    public void setAverageExecutionTime(Double averageExecutionTime) {
        this.averageExecutionTime = averageExecutionTime;
    }

    @Column(name = "std_dev_execution_time")
    public Double getStdDevExecutionTime() {
        return stdDevExecutionTime;
    }

    public void setStdDevExecutionTime(Double stdDevExecutionTime) {
        this.stdDevExecutionTime = stdDevExecutionTime;
    }

    @Column(name = "min_row_count")
    public Integer getMinRowCount() {
        return minRowCount;
    }

    public void setMinRowCount(Integer minRowCount) {
        this.minRowCount = minRowCount;
    }

    @Column(name = "max_row_count")
    public Integer getMaxRowCount() {
        return maxRowCount;
    }

    public void setMaxRowCount(Integer maxRowCount) {
        this.maxRowCount = maxRowCount;
    }

    @Column(name = "cumulative_row_count")
    public Integer getCumulativeRowCount() {
        return cumulativeRowCount;
    }

    public void setCumulativeRowCount(Integer cumulativeRowCount) {
        this.cumulativeRowCount = cumulativeRowCount;
    }

    @Column(name = "average_row_count")
    public Double getAverageRowCount() {
        return averageRowCount;
    }

    public void setAverageRowCount(Double averageRowCount) {
        this.averageRowCount = averageRowCount;
    }

    @Column(name = "std_dev_row_count")
    public Double getStdDevRowCount() {
        return stdDevRowCount;
    }

    public void setStdDevRowCount(Double stdDevRowCount) {
        this.stdDevRowCount = stdDevRowCount;
    }

}