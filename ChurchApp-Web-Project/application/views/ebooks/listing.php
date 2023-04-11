
<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Ebooks</h2>
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
                                    <th>Category</th>
                                  <th>Name</th>
                                  <th>Thumbnail</th>
                                  <th class="text-center">Actions</th>
                                </tr>
                                </thead>
                              <tbody>
                                  <?php
                                  $count=1;
                                  forEach($ebooks as $record){
                                  ?>
                                  <tr>
                                    <td><?php echo $count; ?></td>
                                      <td><?php echo $record->category; ?></td>
                                    <td><?php echo $record->name; ?></td>
                                    <td style="text-align:center;"><img src="<?php echo $record->thumbnail; ?>" style="height:50px; width:50px;"></img></td>
                                    <td class="text-center">
                                      <div class="btn-group btn-group-sm" style="float: none;">
                                        <a href="<?php echo site_url().'editEbook/'.$record->id; ?>" type="button" class="btn btn-primary btn-lg m-l-15 waves-effect" style="float: none;">
                                          <i style="margin-bottom:5px;" class="material-icons list-icon" data-id="<?php echo $record->id; ?>">create</i>
                                        </a>
                                        <button onclick="delete_item(event)" data-type="ebook" data-id="<?php echo $record->id; ?>" type="button" class="btn btn-danger btn-lg m-l-15 waves-effect" style="float: none;">
                                         <i style="color:white;margin-bottom:5px;"  class="material-icons list-icon" data-type="ebook" data-id="<?php echo $record->id; ?>">delete</i>
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
