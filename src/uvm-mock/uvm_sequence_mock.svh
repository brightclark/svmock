`ifndef SVMOCK_UVM_SEQUENCE
`define SVMOCK_UVM_SEQUENCE(SEQUENCE_TYPE) \
`SVMOCK(SEQUENCE_TYPE``_mock,SEQUENCE_TYPE) \
 \
  `uvm_object_utils(SEQUENCE_TYPE``_mock) \
 \
  const int signed minus1 = -1; \
 \
  uvm_sequencer #(apb_item) sqr; \
  function new(string name = `"SEQUENCE_TYPE`"); \
    super.new(name); \
 \
    sqr = new("sqr"); \
    set_response_queue_depth(-1); \
  endfunction \
 \
  `SVMOCK_TASK3(start_item,,uvm_sequence_item,item,,,,int,set_priority,,minus1,,uvm_sequencer_base,sequencer,,null) \
 \
  `SVMOCK_TASK2(finish_item,, uvm_sequence_item,  item,,, \
                            , int,                set_priority,,minus1) \
 \
  `SVMOCK_TASK4(start,, uvm_sequencer_base, sequencer,,, \
                      , uvm_sequence_base,  parent_sequence,,null, \
                      , int,                this_priority,,minus1, \
                      , bit,                call_pre_post,,minus1) \
 \
  `SVMOCK_MAP_TASK4(start,_start) \
  virtual task _start (uvm_sequencer_base sequencer, \
                       uvm_sequence_base parent_sequence, \
                       int this_priority, \
                       bit call_pre_post); \
    clear_response_queue(); \
 \
    fork \
      forever begin \
        apb_item _item; \
 \
        sqr.get_next_item(_item); \
        sqr.item_done(_item); \
      end \
    join_none \
 \
    /* run the sequence and kill the above when it's done */ \
    super.start(sqr); \
    disable fork; \
  endtask \
 \
`SVMOCK_END
`endif
