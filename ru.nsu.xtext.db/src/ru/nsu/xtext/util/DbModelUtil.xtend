package ru.nsu.xtext.util

import org.eclipse.emf.ecore.EObject
import ru.nsu.xtext.dbDsl.DbModel

import static extension org.eclipse.xtext.EcoreUtil2.*
import ru.nsu.xtext.dbDsl.Column
import ru.nsu.xtext.dbDsl.Table
import ru.nsu.xtext.dbDsl.Database
import org.eclipse.xtext.naming.QualifiedName

class DbModelUtil {
	def static root(EObject e) {
		e.getContainerOfType(typeof(DbModel))
	}
	
	def static qualifiedName(Column col){
		val table = col.getContainerOfType(typeof(Table))
		val db = col.getContainerOfType(typeof(Database))
		
		QualifiedName::create(db.name,table.name,col.name)
	}
}