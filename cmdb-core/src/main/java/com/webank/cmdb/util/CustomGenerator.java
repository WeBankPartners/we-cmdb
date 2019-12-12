package com.webank.cmdb.util;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import org.hibernate.MappingException;
import org.hibernate.boot.model.naming.ObjectNameNormalizer;
import org.hibernate.engine.jdbc.env.spi.JdbcEnvironment;
import org.hibernate.engine.spi.SharedSessionContractImplementor;
import org.hibernate.id.Configurable;
import org.hibernate.id.IdentifierGenerator;
import org.hibernate.id.IdentifierGeneratorHelper;
import org.hibernate.id.IntegralDataTypeHolder;
import org.hibernate.id.PersistentIdentifierGenerator;
import org.hibernate.internal.util.StringHelper;
import org.hibernate.mapping.Table;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.type.Type;

public class CustomGenerator implements IdentifierGenerator,Configurable {

	private Class<?> returnClass;
	private String sql;

	private IntegralDataTypeHolder previousValueHolder;
	
	public CustomGenerator() {
		super();
	}

	@Override
	public Serializable generate(SharedSessionContractImplementor session, Object object){
		final Serializable id = session.getEntityPersister( null, object ).getIdentifier( object, session );
		if(id != null) {
			return (Serializable)id;
		}
		if ( sql != null ) {
			initializePreviousValueHolder( session );
		}
		return previousValueHolder.makeValueThenIncrement();
	}
	@SuppressWarnings("deprecation")
	@Override
	public void configure(Type type, Properties params, ServiceRegistry serviceRegistry) throws MappingException {
		returnClass = type.getReturnedClass();

		final JdbcEnvironment jdbcEnvironment = serviceRegistry.getService( JdbcEnvironment.class );
		final ObjectNameNormalizer normalizer =
				(ObjectNameNormalizer) params.get( PersistentIdentifierGenerator.IDENTIFIER_NORMALIZER );

		String column = params.getProperty( "column" );
		if ( column == null ) {
			column = params.getProperty( PersistentIdentifierGenerator.PK );
		}
		column = normalizer.normalizeIdentifierQuoting( column ).render( jdbcEnvironment.getDialect() );

		String tableList = params.getProperty( "tables" );
		if ( tableList == null ) {
			tableList = params.getProperty( PersistentIdentifierGenerator.TABLES );
		}
		String[] tables = StringHelper.split( ", ", tableList );

		final String schema = normalizer.toDatabaseIdentifierText(
				params.getProperty( PersistentIdentifierGenerator.SCHEMA )
		);
		final String catalog = normalizer.toDatabaseIdentifierText(
				params.getProperty( PersistentIdentifierGenerator.CATALOG )
		);

		StringBuilder buf = new StringBuilder();
		for ( int i = 0; i < tables.length; i++ ) {
			final String tableName = normalizer.toDatabaseIdentifierText( tables[i] );
			if ( tables.length > 1 ) {
				buf.append( "select max(" ).append( column ).append( ") as mx from " );
			}
			buf.append( Table.qualify( catalog, schema, tableName ) );
			if ( i < tables.length - 1 ) {
				buf.append( " union " );
			}
		}
		if ( tables.length > 1 ) {
			buf.insert( 0, "( " ).append( " ) ids_" );
			column = "ids_.mx";
		}

		sql = "select max(" + column + ") from " + buf.toString();
	}

	private void initializePreviousValueHolder(SharedSessionContractImplementor session) {
		previousValueHolder = IdentifierGeneratorHelper.getIntegralDataTypeHolder( returnClass );
		try {
			PreparedStatement st = session.getJdbcCoordinator().getStatementPreparer().prepareStatement( sql );
			try {
				ResultSet rs = session.getJdbcCoordinator().getResultSetReturn().extract( st );
				try {
					if ( rs.next() ) {
						previousValueHolder.initialize( rs, 0L ).increment();
					}
					else {
						previousValueHolder.initialize( 1L );
					}
					//sql = null;
				}
				finally {
					session.getJdbcCoordinator().getLogicalConnection().getResourceRegistry().release( rs, st );
				}
			}
			finally {
				session.getJdbcCoordinator().getLogicalConnection().getResourceRegistry().release( st );
				session.getJdbcCoordinator().afterStatementExecution();
			}
		}
		catch (SQLException sqle) {
			throw session.getJdbcServices().getSqlExceptionHelper().convert(
					sqle,
					"could not fetch initial value for increment generator",
					sql
			);
		}
	}

}
