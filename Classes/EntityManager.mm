/*
 *  EntityManager.cpp
 *  components
 *
 *  Created by jrk on 3/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#include "SystemConfig.h"
#import "Entity.h"
#import "EntityManager.h"
#import "Component.h"
#include <vector>
#include <typeinfo>
namespace mx3 
{
	
		
	EntityManager::EntityManager ()
	{
		CV3Log ("EntityManager startup:\n{\n");
		CV3Log ("\t[*] Entity Slots: %i\n", MAX_ENTITIES);
		CV3Log ("\t[*] Component Slots per Entity: %i\n", MAX_COMPONENTS_PER_ENTITY);
		CV3Log ("\t[!] don't exceed these limits without adjusting the #defines!\n");
		CV3Log ("\t[!] no checks/asserts will be made for this! you will crash and burn!\n}\n");
		
		Entity::entityManager = this;
		is_dirty = true;
		for (int i = 0; i < MAX_ENTITIES; i++)
		{
			_entities[i] = NULL;
			for (int j = 0; j < MAX_COMPONENTS_PER_ENTITY; j++)
			{
				_components[i][j] = NULL;
			}
		}
	}



	EntityGUID EntityManager::getNextAvailableID() 
	{
		for (EntityGUID i = 1; i < MAX_ENTITIES; i++)
			if (_entities[i] == 0)
				return i;

		CV3Log ("** Fast Entity Manager error:\n\t[!] NO ENTITY SLOTS FREE! MAX_ENTITIES: %i\n", MAX_ENTITIES);
		abort();
		return -1; //oh oh we fucked up
	}



	Entity *EntityManager::createNewEntity (void)
	{
		Entity *e = new Entity (this->getNextAvailableID());
		is_dirty = true;
		return this->getEntity(e->_guid);
	}

	void EntityManager::registerEntity(Entity *e) 
	{
		is_dirty = true;
		//_entities.insert(std::pair<EntityGUID, Entity*>(e->_guid, e));
		e->checksum = generateChecksum();
		_entities[e->_guid] = e;
	}

	Entity *EntityManager::getEntity(EntityGUID _id) 
	{
		return _entities[_id];
	}

	void EntityManager::removeEntity(EntityGUID _id) 
	{
		is_dirty = true;
		Entity *e = _entities[_id];
		removeAllComponents(e);
		
		//std::map<EntityGUID, Entity*>::iterator toKill = _entities.find(_id);
		//_entities.erase(toKill);
		_entities[_id] = NULL;
	}

	void EntityManager::removeAllEntities (void)
	{
		is_dirty = true;
		
		Entity *e = NULL;
		for (int i = 0; i < MAX_ENTITIES; i++)
		{
			e = _entities[i];
			if (e)
			{
				removeEntity(e->_guid);
			}
		}
	}

	void EntityManager::dumpEntityCount (void)
	{
		int count = 0;
		for (int i = 0; i < MAX_ENTITIES; i++)
		{
			if (_entities[i])
				count ++;
		}
		CV3Log ("** EntityManager entity count: %i\n", count);
		
		if ((MAX_ENTITIES-count) < 20)
		{
			CV3Log ("\t[!] MAX_ENTITES is %i - you are reaching the limit!\n", MAX_ENTITIES);
		}
	}

	void EntityManager::dumpEntity (Entity *e)
	{
		//std::map<EntityGUID, Entity *>::const_iterator it = _entities.begin();
		//std::map<EntityGUID, Entity *>::const_iterator end = _entities.end();
		
		CV3Log ("\n\n************** DUMP *************\n");
		CV3Log ("entity ID: %i, checksum: %i, address: %p (%s)\n{\n", e->_guid,e->checksum, e, typeid(e).name());
		dumpComponents(e);	
		CV3Log ("}\n************** DUMP END *************\n");
	}


	void EntityManager::dumpEntities(void)
	{
		Entity *e = NULL;
		CV3Log ("\n\n************** DUMP *************\n");
		for (int i = 0; i < MAX_ENTITIES; i++)
		{
			e = _entities[i];
			if (e)
			{		
				CV3Log ("entity ID: %i, checksum: %i, address: %p (%s)\n{\n", e->_guid,e->checksum, e, typeid(e).name());			
				dumpComponents(e);
				CV3Log ("}\n");
			}
		}
		CV3Log ("************** DUMP END *************\n");	
	}

	void EntityManager::dumpComponent (Entity *e, Component *c)
	{
	#ifdef __RUNTIME_INFORMATION__
		CV3Log ("\t+[%i] %p (%s)\n",c->_id,c,c->toString().c_str() );
	#else
		CV3Log ("\t+ %p\n",c);
	#endif
	}

	void EntityManager::dumpComponents (Entity *e)
	{
		
		Component *c = NULL;
		for (int i = 0; i < MAX_COMPONENTS_PER_ENTITY; i++)
		{
			c = _components[e->_guid][i];
			if (c)
			{
	#ifdef __RUNTIME_INFORMATION__
				CV3Log ("\t+[%i] %p (%s)\n",c->_id,c,c->toString().c_str() );
	#else
				CV3Log ("\t+ %p\n",c);
	#endif
				
			}
		}
	}
	#define NUM_FAMILY_IDS 32
	void EntityManager::getEntitiesPossessingComponents (std::vector<Entity*> &result, ...)
	{
		va_list listPointer;
		va_start( listPointer, result );
		
		ComponentID family_ids[NUM_FAMILY_IDS+1];
		ComponentID arg;
		int count = 0;
		while (1)
		{
			arg = va_arg( listPointer, int );
			if (arg == -1 || count >= NUM_FAMILY_IDS)
				break;
			family_ids[count] = arg;
			++count;
		}
		va_end(listPointer);
		
		Entity *current_entity = NULL;
		bool is_entity_valid = true;
		for (int i = 0; i < MAX_ENTITIES; i++)
		{
			current_entity = _entities[i];
			is_entity_valid = true;
		
			if (current_entity)
			{
				for (int j = 0; j < count; j++)
				{
					if (!_components[current_entity->_guid][family_ids[j]])
					{
						is_entity_valid = false;
						break;
					}
				}
				
				if (is_entity_valid)
				{
					result.push_back (current_entity);
				}
			}
		}
		
		
	}

	void EntityManager::getEntitiesPossessingComponent (std::vector <Entity*> &result, ComponentID familyId)
	{
		
		Entity *current_entity = NULL;
		bool is_entity_valid = true;
		for (int i = 0; i < MAX_ENTITIES; i++)
		{
			current_entity = _entities[i];
			is_entity_valid = true;
			
			if (current_entity)
			{
				if (_components[current_entity->_guid][familyId])
				{
					result.push_back (current_entity);
				}
			}
		}
		
		
	}


	void EntityManager::removeAllComponents (Entity *e)
	{
		is_dirty = true;
		
		Component *comp = NULL;
		for (int i = 0; i < MAX_COMPONENTS_PER_ENTITY; i++)
		{
			comp = _components[e->_guid][i];
			delete comp;
			_components[e->_guid][i] = NULL;
		}
	}

	//our entity ids are not unique in time. our checksums are!
	unsigned int EntityManager::generateChecksum()
	{
		static unsigned int counter = 0;
		return ++counter;
	}

}