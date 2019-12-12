package com.webank.cmdb.util;

import java.io.Serializable;

import org.hibernate.engine.spi.SharedSessionContractImplementor;
import org.hibernate.id.IncrementGenerator;

public class CustomGenerator extends IncrementGenerator{
	
	
	public CustomGenerator() {
		super();
	}

	@Override
	public Serializable generate(SharedSessionContractImplementor session, Object object){
		final Serializable id = session.getEntityPersister( null, object ).getIdentifier( object, session );
        return id != null ? id : super.generate(session, object);
	}

}
