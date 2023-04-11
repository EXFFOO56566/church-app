
<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Donations</h2>
            <ol class="breadcrumb align-right">
                <li>
                    <a type="button" href="<?php echo site_url().'update_donations_api'; ?>"  class="btn  btn-lg btn-primary waves-effect" style="color:white;">Update Donation Api Keys</a>
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
                            <table id="donations_table" class="table table-responsive table-bordered table-striped table-hover">
                                <thead>
                                <tr>
                                  <th>Id</th>
                                  <th>Reason</th>
                                  <th>Email</th>
                                  <th>Name</th>
                                  <th>reference</th>
                                  <th>Amount</th>
                                  <th>Method</th>
                                  <th>Date</th>
                                </tr>
                                </thead>

                            </table>
                          </div>
                        </div>
                    </div>
                </div>
            </div>
</section>
