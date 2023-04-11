<section class="content">
    <div class="container-fluid">
        <div class="block-header">
            <h2>Reported Comments</h2>
        </div>
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">



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
                            <table id="reports_table" class="table table-responsive table-bordered table-striped table-hover exportable">
                                <thead>
                                <tr>
                                  <th>#</th>
                                  <th>Comment</th>
                                  <th>Reason</th>
                                  <th>Comment By</th>
                                  <th>Reported By</th>
                                  <th>Date</th>
                                  <th class="text-center">Actions</th>
                                </tr>
                                </thead>

                                <tbody>
                                    <?php
                                    $count=1;
                                    forEach($reports as $r){
                                    ?>
                                    <tr>
                                      <td><?php echo $count; ?></td>
                                      <td><?php echo base64_decode($r->content); ?></td>
                                      <td><?php echo $r->reason; ?></td>
                                      <td><?php echo $r->commented_by; ?></td>
                                      <td><?php echo $r->email; ?></td>
                                      <td><?php echo date("Y-m-d",$r->date); ?></td>
                                     <td class="text-center">
                                       <div class="btn-group btn-group-sm" style="float: none;">
                                         <button title="Send Mail to commenter" onclick="warn_user(event)" data-comment="<?php echo $r->content; ?>" data-email="<?php echo $r->commented_by; ?>" type="button" class="tabledit-edit-button btn btn-sm btn-default" style="float: none;">
                                           <i style="margin-bottom:5px;" onclick="warn_user(event)" class="material-icons list-icon" data-comment="<?php echo $r->content; ?>" data-email="<?php echo $r->commented_by; ?>">email</i>
                                         </button>
                                         <button title="Delete Report" onclick="delete_item(event)" data-id="<?php echo $r->id; ?>" data-type="reports" type="button" class="tabledit-delete-button btn btn-sm btn-default" style="float: none;">
                                          <i style="color:red;margin-bottom:5px;" onclick="delete_item(event)" class="material-icons list-icon" data-type="reports" data-id="<?php echo $r->id; ?>">delete</i>
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
