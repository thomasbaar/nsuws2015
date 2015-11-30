package ru.nsu.xtext.db.tests


import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import ru.nsu.xtext.DbDslInjectorProvider
import ru.nsu.xtext.dbDsl.DbModel

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(DbDslInjectorProvider))
class DbParserTest {
	@Inject extension ParseHelper<DbModel>
	@Inject extension ValidationTestHelper
	
	@Test def testForeignKey() {
		'''database persons;
			create table student {
				name varchar;
				id int;
				supervisor int;
				groupspeaker int;
				foreign key supervisor references persons.teacher.id;
				foreign key groupspeaker references id;
			}
			create table teacher{
				id int;
			}
		'''.parse.assertNoErrors
	}
	
	/**
	 * test fails if run with standard ScopeProvider
	 */
	@Test def testReferredColumnAsSimpleName() {
		'''database persons;
			create table student {
				supervisor int;
				foreign key supervisor references teacherid;
			}
			create table teacher{
				teacherid int;
			}
		'''.parse.assertNoErrors
	}
	
}