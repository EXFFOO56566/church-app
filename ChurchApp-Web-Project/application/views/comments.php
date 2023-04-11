<section class="content">
    <div class="container-fluid">
        <div class="block-header">
            <h2>Comments</h2>
        </div>



            <!-- Exportable Table -->
            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                      <div class="card-header">
                          <h2 class="pull-right">
                            <div class="col-sm-4">
                                 <div class="form-group">
                                     <div class="input-group addon-line">
                                      <div class="form-line">
                                              <input type="text" value="<?php if(isset($_GET['date']) && isset($_GET['date2'])){echo $_GET['date'].' - '.$_GET['date2']; }?>" name="daterange" id="reportrange" class="form-control ">
                                         </div>
                                         <span class="input-group-addon"><button onclick="view_comments_by_date()" type="button" class="btn btn-primary waves-effect">generate</button></span>
                                     </div>
                                 </div>
                             </div>

                          </h2>
                          <br>
                          <br>
                      </div>

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
                          <div>
                            <table id="comments_table" class="table table-responsive table-bordered table-striped table-hover">
                                <thead>
                                <tr>
                                  <th>#</th>
                                  <th>Comment</th>
                                  <th>Email</th>
                                  <th>Type</th>
                                  <th>Date</th>
                                  <th class="text-center">Actions</th>
                                </tr>
                                </thead>

                            </table>
                          </div>
                        </div>
                    </div>
            </div>
    </div>
</section>
