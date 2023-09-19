class f_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(f_sequence_item, f_scoreboard) item_got_export;
  `uvm_component_utils(f_scoreboard)
  
  function new(string name = "f_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  bit [127:0] queue[$];
  bit full_flag, empty_flag, alm_full_flag, alm_empty_flag;
  bit [9:0] counter;
  int match, mismatch;
  function void write(input f_sequence_item item_got);
   bit [127:0] examdata;
   if(item_got.i_wren == 'b1)begin
      queue.push_back(item_got.i_wrdata);
      counter++;
      if(counter>=1020 && counter<1024) begin
      full_flag=0; 
      empty_flag=0; 
      alm_full_flag=1; 
      alm_empty_flag=0;
      end
     else if(counter==1024) begin
      full_flag=1; 
      empty_flag=0; 
      alm_full_flag=0; 
      alm_empty_flag=0;
     end
//      write_func(counter);
     `uvm_info("write Data", $sformatf("wr: %0b rd: %0b data_in: %0h full: %0b alm_full: %0b",item_got.i_wren, item_got.i_rden,item_got.i_wrdata, item_got.o_full, item_got.o_alm_full), UVM_LOW);
    end
    
    
    else if (item_got.i_rden == 'b1)begin
      if(queue.size() >= 'd1)begin
        examdata = queue.pop_front();
        counter--;
        if(counter>0 && counter<=2) begin
        full_flag=0; 
        empty_flag=0; 
        alm_full_flag=0; 
        alm_empty_flag=1;
        end
        else if(counter==0) begin
        full_flag=0; 
        empty_flag=1; 
        alm_full_flag=0; 
        alm_empty_flag=0;
        end
        `uvm_info("Read Data", $sformatf("examdata: %0h data_out: %0h empty: %0b alm_empty: %0b", examdata, item_got.o_rddata, item_got.o_empty, item_got.o_alm_empty), UVM_LOW);
        if(examdata == item_got.o_rddata) 
          $display("test");
           if(full_flag==item_got.o_full && empty_flag==item_got.o_empty && alm_full_flag==item_got.o_alm_full && alm_empty_flag==item_got.o_alm_empty)begin
          $display("--------		Pass		--------");
          $display("match = %0d  mismatch = %0d", match++, mismatch);
        end
        else begin
          $display("--------		Fail!		--------");
          $display("match = %0d  mismatch = %0d", match, mismatch++);
        end
      end
    end
  endfunction
  
//   function void write_func (bit [9:0] cnt);
//     if(counter>=1020 && counter<1024) begin
//       full_flag=0; 
//       empty_flag=0; 
//       alm_full_flag=1; 
//       alm_empty_flag=0;
//       return alm_full_flag
//     end
//   endfunction
endclass
        
