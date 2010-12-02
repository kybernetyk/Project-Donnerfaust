/*
 *  EntityManager.h
 *  components
 *
 *  Created by jrk on 3/11/10.
 *  Copyright 2010 Minyx Games. All rights reserved.
 *

 This is the EntityManager which manages all the entities and their creation/destruction + component addition/removal.
 
-- 
 To create a new entity and add a component:
 
 Entity *e = myManager->createNewEntity();
 myManager->addComponent (e, new PositionComponent);
 myManager->addComponent (e, new RenderableComponent); 
 myManager->addComponent (e, new EnemyBehavior);

--
 To retrieve a component from an entity:
 PositionComponent *p = myManager->getComponent<PositionComponent>(e);
 OR:
 PositionComponent *p = e->getComponent<PositionComponent>(); //which calls the first method
 
--
 To delete the entity and its components:
 myManager->killEntity(e->_guid);
 
--
 To query the manager for entities with a certain component family:

 std::set<Entity*> positionList;
 myManager->getEntitiesWithComponentFamily <Position> (positionList);

 LOL THIS IS OUTDATED! DONT TRUST xD
 */
//TODO: add component removal from entities, add component removal from manager (in case of kill, etc)
#pragma once
#include "SystemConfig.h"

#include <stdio.h>
#include <map>
#include <set>
#import "types.h"
#include <vector>
#include "Component.h"
#include "Entity.h"


namespace mx3 
{
	
		
	struct Component;


	class EntityManager
	{
	public:
		EntityManager();
		EntityGUID getNextAvailableID();
		
		Entity *createNewEntity (void);
		void registerEntity(Entity *e);
		void removeEntity(EntityGUID _id);
		void removeAllEntities (void);
		
		
		Entity *getEntity(EntityGUID _id);
		
		void getEntitiesPossessingComponent (std::vector<Entity*> &result, ComponentID familyId);
		void getEntitiesPossessingComponents (std::vector<Entity*> &result, ...);

		template<typename T> T *addComponent(Entity *e)
		{
			is_dirty = true;

	#ifdef __ABORT_GUARDS__			
			if (T::COMPONENT_ID >= MAX_COMPONENTS_PER_ENTITY)
			{
				CV3Log ("** Entity Manager Error!\t[!] No more Entity slots free!\n\t\tMAX_SLOTS: %i | Component ID: %i\n",MAX_COMPONENTS_PER_ENTITY,T::COMPONENT_ID);
				abort();
				return NULL;
			}

			if (T::COMPONENT_ID == 0)
			{
				CV3Log ("** Entity Manager Error!\t[!] Component ID 0 is reserved! You may not use that!\n");
				abort();
				return NULL;
			}
	#endif
			
			T *comp = new T();
			
			if (_components[e->_guid][T::COMPONENT_ID])
			{
				//printf("warning: replacing component (%p / %i) on Entity (%p) without cleanup!\n", _components[e->_guid][T::COMPONENT_ID],T::COMPONENT_ID, e);
	#ifdef __ENTITY_MANAGER_WARNINGS__
				CV3Log ("this slot is already used by a component. you want to replace the component @ slot %i which is: [%s]\n", T::COMPONENT_ID,_components[e->_guid][T::COMPONENT_ID]->toString().c_str());
				CV3Log ("the component's parent entity:");
				dumpEntity(e);
				CV3Log ("I am now removing this component and adding the new one!\n");
	#endif
				removeComponent <T> (e);
				
			}

			
			_components[e->_guid][T::COMPONENT_ID] = comp;
			return comp;
		}

		Component *addComponent(Entity *e, Component *comp)
		{
			is_dirty = true;

	#ifdef __ABORT_GUARDS__
			if (comp->_id >= MAX_COMPONENTS_PER_ENTITY)
			{
				CV3Log ("** Fast Entity Manager Error!\t[!] No more Entity slots free!\n\t\tMAX_SLOTS: %i | Component ID: %i\n",MAX_COMPONENTS_PER_ENTITY,comp->_id);
				abort();
				return NULL;
			}
			
			if (comp->_id == 0)
			{
				CV3Log ("** Fast Entity Manager Error!\t[!] Component ID 0 is reserved! You may not use that!\n");
				abort();
				return NULL;
			}
	#endif		

			if (_components[e->_guid][comp->_id])
			{
				//printf("warning: replacing component (%p / %i) on Entity (%p) without cleanup!\n", _components[e->_guid][T::COMPONENT_ID],T::COMPONENT_ID, e);
	#ifdef __ENTITY_MANAGER_WARNINGS__

				CV3Log ("this slot is already used by a component. you want to replace the component @ slot %i which is: [%s]\n", comp->_id,_components[e->_guid][comp->_id]->toString().c_str());
				CV3Log ("the component's parent entity:");
				dumpEntity(e);
				
				CV3Log ("I am now removing this component and adding the new one!\n");
	#endif
	//			removeComponent <T> (e);
				removeComponent(e, _components[e->_guid][comp->_id]);
				
			}

			
			_components[e->_guid][comp->_id] = comp;
			return comp;
		}
		
		//component query
		template <typename T> T *getComponent(Entity *e) 
		{
			return (T*)_components[e->_guid][T::COMPONENT_ID];
		}

		Component *getComponent(Entity *e, ComponentID _id) 
		{
			return _components[e->_guid][_id];
		}
		
		
		template<typename T> void removeComponent(Entity *e)
		{
			Component *component = _components[e->_guid][T::COMPONENT_ID];
			delete component;
			_components[e->_guid][T::COMPONENT_ID] = NULL;
			is_dirty = true;
		}
		
		void removeComponent(Entity *e, Component *comp)
		{
			_components[e->_guid][comp->_id] = NULL;
			delete comp;
			
			is_dirty = true;
		}
		
		void removeComponent (Entity *e, ComponentID _id)
		{
			Component *comp =  _components[e->_guid][_id];
			_components[e->_guid][_id] = NULL;
			delete comp;
			
			is_dirty = true;
		}
		
		void removeAllComponents (Entity *e);
		
		void dumpEntity (Entity *e);
		void dumpEntityCount (void);
		void dumpEntities (void);
		void dumpComponent (Entity *e, Component *c);
		void dumpComponents (Entity *e);
		
		
		
		bool isDirty ()
		{
			return is_dirty;
		}
		
		void setIsDirty (bool b)
		{
			is_dirty = b;
		}
		
		unsigned int generateChecksum();
		
	protected:
		bool is_dirty;
		
		Entity *_entities[MAX_ENTITIES];	//index is entity id
		Component *_components[MAX_ENTITIES][MAX_COMPONENTS_PER_ENTITY];	//[entity_id][component_id]
	};

}