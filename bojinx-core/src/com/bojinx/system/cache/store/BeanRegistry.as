package com.bojinx.system.cache.store
{
	import avmplus.getQualifiedClassName;
	
	import com.bojinx.api.context.IApplicationContext;
	import com.bojinx.api.context.config.IBean;
	import com.bojinx.api.context.config.IResolvableBean;
	import com.bojinx.reflection.ClassInfo;
	
	import flash.utils.Dictionary;

	public class BeanRegistry
	{
		private var beansByType:Dictionary = new Dictionary();
		private var beansById:Dictionary = new Dictionary();
		private var context:IApplicationContext;
		
		public function BeanRegistry(context:IApplicationContext)
		{
			this.context = context;
		}
		
		public function register(bean:IBean, includeByType:Boolean = true):void
		{
			if(includeByType && bean is IResolvableBean && !beansByType[IResolvableBean(bean).source])
				beansByType[IResolvableBean(bean).source] = bean;
			
			beansById[bean.id] = bean;
		}
		
		public function getBeanById(id:String):IBean
		{
			if(beansById[id])
			{
				return beansById[id];
			}
			else if(context.parent && context.viewSettings.inheritFromParentContext)
			{
				return context.parent.cache.beans.getBeanById(id);
			}
			
			return null;
		}
		
		public function getBeanByType(type:Class):IBean
		{
			var bean:IBean = beansByType[type];
			
			if(!bean)
			{
				var name:String = getQualifiedClassName(type);
				for each(var i:IResolvableBean in beansByType)
				{
					if(i.implementsInterface(name))
						return i;
				}
			}
			
			if(!bean && context.parent && context.parent.viewSettings.inheritFromParentContext)
			{
				return context.parent.cache.beans.getBeanByType(type);
			}
			
			return bean;
		}
		
		public function getAllBeansByType(type:Class):Array
		{
			var result:Array = [];
			
			for each(var i:IBean in beansById)
			{
				if(i is type)
					result.push(i);
			}
			
			return result;
		}
		
		private function isSubclassOf(a:Class, b:Class): Boolean
		{
			if (int(!a) | int(!b)) return false;
			return (a == b || a.prototype is b);
		}
	}
}