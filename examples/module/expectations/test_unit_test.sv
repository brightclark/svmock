`include "svunit_defines.svh"
`include "test.v"
`include "clk_and_reset.svh"

module test_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "test_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  bit       bit_i;
  bit [7:0] byte_i;
  wire       bit_o;
  wire [7:0] byte_o;

  `CLK_RESET_FIXTURE(5, 11)

  test my_test(clk,
               rst_n,
               bit_o,
               byte_o,
               bit_i,
               byte_i);


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */

  endtask


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

  // Temporal expectation
  `SVTEST(simple_expectation)
    `EXPECT(my_test, bit_o)
      `EQ(0);             // LT(), EQ(), GT(), BETWEEN(a,b), WITHIN([a..b])
      `ONCE();            // TIMES(n)
                          //    `CONSECUTIVELY()
      `AT(8);             // AT(a), AFTER(a), BEFORE(b), WITHIN(a,b)

    step(9);
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
