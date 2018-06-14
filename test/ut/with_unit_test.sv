`include "svunit_defines.svh"

import ut_pkg::*;

module with_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "with_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  mock_call ut;

  int assocPeter [string] = '{ "Peter":20 };
  int queueHank [$] = { 14, 15, 16 };
  string fixedGlenn [10] = '{10{"clank"}};
  objtype dynamicFred [];


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    ut = new(/* New arguments if needed */);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
    set_defaults();

    ut.clear();
  endtask

  function void set_defaults();
    assocPeter = '{ "Peter":20 };
    queueHank = { 14, 15, 16 };
    fixedGlenn = '{10{"clank"}};
    dynamicFred = new[10];
    foreach (dynamicFred[i]) dynamicFred[i] = new();
  endfunction


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

  // unit tests for expect_call. here's a template from
  // googlemock as a guide...
  //
  // EXPECT_CALL(mock_object, Method(argument-matchers))
  //     .With(multi-argument-matchers)
  //     .Times(cardinality) // AtLeast, AtMost, Between, Exactly
  //     .InSequence(sequences)
  //     .After(expectations)
  //     .WillOnce(action)
  //     .WillRepeatedly(action)
  //     .RetiresOnSaturation();


  //---------------------------------
  //         With Discrete
  //---------------------------------

  `SVTEST(WithOneArg)
    `EXPECT_CALL(ut, functionIntArgReturnVoid).With(3);

    ut.functionIntArgReturnVoid(3);
    `FAIL_UNLESS(ut.check());

    ut.functionIntArgReturnVoid(2);
    `FAIL_IF(ut.check());
  `SVTEST_END

  `SVTEST(WithTwoArgs)
    `EXPECT_CALL(ut, functionIntStringArgsReturnVoid).With(3, "heck");

    ut.functionIntStringArgsReturnVoid(3, "heck");
    `FAIL_UNLESS(ut.check());

    ut.functionIntStringArgsReturnVoid(3, "whack");
    `FAIL_IF(ut.check());

    ut.functionIntStringArgsReturnVoid(2, "heck");
    `FAIL_IF(ut.check());
  `SVTEST_END

  `SVTEST(WithThreeArgs)
    objtype dt = new();
 
    `EXPECT_CALL(ut, functionObjBitLogicArgsReturnVoid).With(dt, 0, 27);
 
    ut.functionObjBitLogicArgsReturnVoid(dt, 0, 27);
    `FAIL_UNLESS(ut.check());
 
    ut.functionObjBitLogicArgsReturnVoid(null, 0, 27);
    `FAIL_IF(ut.check());
  `SVTEST_END


  //---------------------------------
  //      With Aggregate Types
  //---------------------------------

  `SVTEST(WithAssocArg)
    `EXPECT_CALL(ut, functionAssocArgReturnVoid).With(assocPeter);

    ut.functionAssocArgReturnVoid(assocPeter);
    `FAIL_UNLESS(ut.check());

    assocPeter["Peter"] = 21; 
    ut.functionAssocArgReturnVoid(assocPeter);
    `FAIL_IF(ut.check());
  `SVTEST_END

  `SVTEST(WithQueueArg)
    `EXPECT_CALL(ut, functionQueueArgReturnVoid).With(queueHank);
 
    ut.functionQueueArgReturnVoid(queueHank);
    `FAIL_UNLESS(ut.check());

    queueHank[0] = 21; 
    ut.functionQueueArgReturnVoid(queueHank);
    `FAIL_IF(ut.check());

    set_defaults();
    queueHank.push_back(99);
    ut.functionQueueArgReturnVoid(queueHank);
    `FAIL_IF(ut.check());

    void'(queueHank.pop_back());
    ut.functionQueueArgReturnVoid(queueHank);
    `FAIL_UNLESS(ut.check());
  `SVTEST_END

  `SVTEST(WithAssocQueueArg)
    `EXPECT_CALL(ut, functionAssocQueueArgReturnVoid).With(assocPeter, queueHank);
 
    ut.functionAssocQueueArgReturnVoid(assocPeter, queueHank);
    `FAIL_UNLESS(ut.check());

    queueHank[0] = 21; 
    ut.functionAssocQueueArgReturnVoid(assocPeter, queueHank);
    `FAIL_IF(ut.check());

    set_defaults();
    assocPeter["Peter"] = 21; 
    ut.functionAssocQueueArgReturnVoid(assocPeter, queueHank);
    `FAIL_IF(ut.check());

    set_defaults();
    ut.functionAssocQueueArgReturnVoid(assocPeter, queueHank);
    `FAIL_UNLESS(ut.check());
  `SVTEST_END

  `SVTEST(WithFixedArrayArg)
    `EXPECT_CALL(ut, functionFixedArrayArgReturnVoid).With(fixedGlenn, 8);
 
    ut.functionFixedArrayArgReturnVoid(fixedGlenn, 8);
    `FAIL_UNLESS(ut.check());

    fixedGlenn[0] = "feathers"; 
    ut.functionFixedArrayArgReturnVoid(fixedGlenn, 8);
    `FAIL_IF(ut.check());
  `SVTEST_END

  `SVTEST(WithDynamicArrayArg)
    `EXPECT_CALL(ut, functionDynamicArrayArgReturnVoid).With("what", dynamicFred, 44);
 
    ut.functionDynamicArrayArgReturnVoid("what", dynamicFred, 44);
    `FAIL_UNLESS(ut.check());

    dynamicFred[8] = new();
    ut.functionDynamicArrayArgReturnVoid("what", dynamicFred, 44);
    `FAIL_IF(ut.check());
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
