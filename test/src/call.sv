class call;
  function void functionNoArgReturnVoid();
  endfunction

  function void functionIntArgReturnVoid(int x);
  endfunction

  function int functionNoArgReturnInt();
    return 1;
  endfunction

  function int functionIntArgReturnInt(int y);
    return y;
  endfunction
endclass