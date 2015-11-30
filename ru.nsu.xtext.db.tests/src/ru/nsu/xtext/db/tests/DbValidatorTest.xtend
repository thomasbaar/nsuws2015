package ru.nsu.xtext.db.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import ru.nsu.xtext.DbDslInjectorProvider
import ru.nsu.xtext.dbDsl.DbModel
import ru.nsu.xtext.dbDsl.DbDslPackage
import ru.nsu.xtext.validation.DbDslValidator

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(DbDslInjectorProvider))
class DbValidatorTest {
	@Inject extension ParseHelper<DbModel>
	@Inject extension ValidationTestHelper

	///////////////////////////////////////////////////////////////////
	// Testing NameIsUnique-validator  
    ///////////////////////////////////////////////////////////////////

	@Test
	def void duplicateDbNotAllowed() {
		val model = '''
			database A ;
			database A ;
			}
		'''.parse
		model.assertError(DbDslPackage::eINSTANCE.database, null)
	}

	@Test
	def void duplicateTableInSameDbNotAllowed() {
		val model = '''
			database A ;
			create table t1 {} 
			create table t1 {} 
		'''.parse
		model.assertError(DbDslPackage::eINSTANCE.table, null)
	}

	@Test
	def void duplicateTableInDifferentDbAllowed() {
		'''
			database A ;
			create table t1 {} 
			database B;
			create table t1 {} 
		'''.parse.assertNoErrors
	}
	
	@Test
	def void duplicateColumnInSameTableNotAllowed() {
		val model = '''
			database A ;
			create table t1 {
				id int;
				id varchar;
			} 
		'''.parse
		model.assertError(DbDslPackage::eINSTANCE.column, null)
	}

	@Test
	def void duplicateColumnInDifferentTableAllowed() {
		'''
			database A ;
			create table t1 {
				id int;
			} 
			create table t2 {
				id varchar;
			} 
		'''.parse.assertNoErrors
	}
	
	
	///////////////////////////////////////////////////////////////////
	// Testing own validator
    ///////////////////////////////////////////////////////////////////

	@Test
	def void fkDeclToColumnOfOtherTypeNotAllowed() {
		val model = '''
		database persons;
			create table student {
				name varchar;
				id int;
				supervisor int;
				groupspeaker int;
				foreign key supervisor references persons.teacher.id;
			}
			create table teacher{
				id varchar;
				name varchar;
			}
		'''.parse
		model.assertError(DbDslPackage::eINSTANCE.foreignKeyDecl, DbDslValidator::TYPE_ERROR_FOR_FK_Decl)
		}
	

	
	
	
}