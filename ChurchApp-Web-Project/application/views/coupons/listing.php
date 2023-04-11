
<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Coupon Codes</h2>
            <ol class="breadcrumb align-right">
                <li>
                    <a type="button" href="<?php echo site_url().'newCoupon'; ?>"  class="btn  btn-lg btn-primary waves-effect" style="color:white;">Generate New</a>
                </li>
                <li>
                    <a type="button" onclick="print_modal_show(event)"  class="btn  btn-lg btn-info waves-effect" style="color:white;">Print Coupons</a>
                </li>
                <li>
                    <a type="button" onclick="delete_modal_show(event)"  class="btn  btn-lg btn-danger waves-effect" style="color:white;">Delete Coupons</a>
                </li>
            </ol>
        </div>


            <!-- Exportable Table -->
            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <?php
                          $this->load->helper('form');
                          $error = $this->session->flashdata('error');
                          if($error)
                          {
                              ?>
                              <div class="alert alert-danger alert-dismissable">
                                  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                  <?php echo $error; ?>
                              </div>
                          <?php }
                          $success = $this->session->flashdata('success');
                          if($success)
                          {
                              ?>
                              <div class="alert alert-success alert-dismissable">
                                  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                  <?php echo $success; ?>
                              </div>
                          <?php } ?>
                          <div style="overflow-x:auto;">
                            <table id="categories-table" class="table table-responsive table-bordered table-striped table-hover exportable">
                                <thead>
                                <tr>
                                  <th>Id</th>
                                  <th>Amount</th>
                                  <th>Code</th>
                                  <th>Duration</th>
                                  <th>Expiry</th>
                                  <th>Created At</th>
                                  <th class="text-center">Actions</th>
                                </tr>
                                </thead>
                              <tbody>
                                  <?php
                                  $count=1;
                                  forEach($coupons as $record){
                                  ?>
                                  <tr>
                                    <td><?php echo $count; ?></td>
                                    <td><?php echo $record->amount; ?></td>
                                    <td><?php echo $record->code; ?></td>
                                    <td><?php echo $record->duration; ?></td>
                                    <td><?php echo $record->expiry; ?></td>
                                    <td><?php echo $record->date; ?></td>
                                    <td class="text-center">
                                      <div class="btn-group btn-group-sm" style="float: none;">

                                        <button onclick="delete_item(event)" data-type="coupon" data-id="<?php echo $record->id; ?>" type="button" class="btn btn-danger btn-lg m-l-15 waves-effect" style="float: none;">
                                         <i style="color:white;margin-bottom:5px;"  class="material-icons list-icon" data-type="coupon" data-id="<?php echo $record->id; ?>">delete</i>
                                        </button>
                                      </div>
                                    </td>
                                   </tr>
                                   <?php $count++;}
                                   ?>
                                </tbody>
                            </table>
                          </div>
                        </div>
                    </div>
                </div>
            </div>
</section>






<div class="modal fade" id="printCoupons" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
        <h4 class="modal-title" id="myModalLabel">Select Coupons to print</h4>
      </div>
      <div class="modal-body">
        <form method="POST" action="<?php echo base_url(); ?>printcoupons" >


          <div class="addon-line" style="margin-top:0px;">

              <div class="form-line">
                <label>Coupon Duration</label>
                  <select class="form-control" name="duration" required="" autofocus="">
                      <option value="One Week">One Week</option>
                      <option value="One Month">One Month</option>
                      <option value="Three Months">Three Months</option>
                      <option value="Six Months">Six Months</option>
                      <option value="One Year">One Year</option>
                  </select>
              </div>
          </div>

          <div class="input-group addon-line" style="margin-top:20px;">
              <label>Currency symbol</label>
              <div class="form-line">
                  <input type="text" value="$" class="form-control" name="currency" placeholder="" required="" autofocus="">
              </div>
          </div>

          <div class="input-group addon-line" style="margin-top:20px;">
              <label>Start From</label>
              <div class="form-line">
                  <input type="number" value="0" class="form-control" name="start" placeholder="" required="" autofocus="">
              </div>
          </div>

          <div class="input-group addon-line" style="margin-top:20px;">
              <label>Limit (How many items to fetch)</label>
              <div class="form-line">
                  <input type="number" value="20" class="form-control" name="limit" placeholder="" required="" autofocus="">
              </div>
          </div>




          <div class="box-footer text-center" style="margin-top:20px;">
             <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
             <button type="submit" class="btn btn-primary">Proceed</button>
          </div>

        </form>
      </div>

    </div>
  </div>
</div>


<div class="modal fade" id="deleteCoupons" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
        <h4 class="modal-title" id="myModalLabel">Select Coupons to delete (Once you click the proceed button, you cant reverse it)</h4>
      </div>
      <div class="modal-body">
        <form method="POST" action="<?php echo base_url(); ?>deleteGroupCoupons" >


          <div class="addon-line" style="margin-top:0px;">

              <div class="form-line">
                <label>Coupon Duration</label>
                  <select class="form-control" name="duration" required="" autofocus="">
                      <option value="One Week">One Week</option>
                      <option value="One Month">One Month</option>
                      <option value="Three Months">Three Months</option>
                      <option value="Six Months">Six Months</option>
                      <option value="One Year">One Year</option>
                  </select>
              </div>
          </div>






          <div class="box-footer text-center" style="margin-top:20px;">
             <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
             <button type="submit" class="btn btn-primary">Proceed</button>
          </div>

        </form>
      </div>

    </div>
  </div>
</div>
