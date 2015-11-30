package ru.nsu.xtext.db.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.scoping.IScopeProvider
import org.junit.Test
import org.junit.runner.RunWith
import ru.nsu.xtext.DbDslInjectorProvider
import ru.nsu.xtext.dbDsl.DbDslPackage
import ru.nsu.xtext.dbDsl.DbModel

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(DbDslInjectorProvider))

class DbScopeProviderTest {
	@Inject extension ParseHelper<DbModel>
	@Inject extension ValidationTestHelper
	@Inject extension IScopeProvider
	

	// fails if customized ScopeProvider is used
	@Test def void testDefaultScopeProvider() {
		runningExample.parse.dbs.get(1).tables.get(1).
		fks.head => [
			assertScope
			(DbDslPackage::eINSTANCE.foreignKeyDecl_Referredcol, 
				// values for default scopeProvider
				"pid, semester, student.pid, student.semester, " +
				"anotherid, " + // thanks to import
                "persons.person.id, persons.person.anotherid, persons.person.name, " +
                "university.student.pid, university.student.semester")
			assertScope
			(DbDslPackage::eINSTANCE.foreignKeyDecl_Fk, 
				// same scope also for Fk-reference!
				"pid, semester, student.pid, student.semester, " +
				"anotherid, " + // thanks to import
                "persons.person.id, persons.person.anotherid, persons.person.name, " +
                "university.student.pid, university.student.semester")
		]
	}
	
	// fails if default ScopeProvider is used
	// note that imported column 'anotherid' is not included here due to the 
	// import-statement in the input file, but just by our implementation of the provider
	@Test def void testCustomizedScopeProvider() {
		runningExample.parse.dbs.get(1).tables.get(1).
		fks.head => [
			assertScope
			(DbDslPackage::eINSTANCE.foreignKeyDecl_Referredcol, 
				// values for default scopeProvider
				"pid, semester, id, anotherid, name, " +
                "persons.person.id, persons.person.anotherid, persons.person.name, " +
                "university.student.pid, university.student.semester")
		]
	}
	
		def private assertScope(EObject context, EReference reference, 
			      CharSequence expected
		) {
		context.assertNoErrors
		expected.toString.assertEquals(
			context.getScope(reference).
				allElements.map[name].join(", "))
	}
	
	
	def getRunningExample(){
		'''database persons;

create table person{
	id int;
	anotherid int;
	name varchar;
}

//create table person{} //duplicate table

database university;

myimport persons.person.anotherid;

create table person{} //non duplicate

create table student{
	pid int;
	semester int;
//	pid int; // duplicate column
	foreign key pid references persons.person.id;
	foreign key pid references semester; // possible
//	foreign key pid references id; //impossible	
}

		'''
	}
	
}