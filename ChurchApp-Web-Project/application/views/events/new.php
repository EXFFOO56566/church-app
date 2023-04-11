<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Add New Event</h2>
        </div>


            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>savenewevent" enctype="multipart/form-data" style="margin-top:30px;">
                            <div class="input-group addon-line">
                                 <label>Event Date</label>
                                <div class="form-line">
                                    <input type="date" class="form-control" name="date" placeholder="Event Date" required="" >
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                 <label>Event Time</label>
                                <div class="form-line">
                                    <input type="time" class="form-control" name="time" placeholder="Event Date" required="" >
                                </div>
                            </div>

                            <div class="input-group addon-line">

                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" placeholder="Event Title" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line">

                                <div class="form-line">
                                    <input type="file" name="thumbnail" data-allowed-file-extensions="png jpg jpeg PNG" class="thumbs_dropify" required>
                                </div>
                            </div>



                            <div class="input-group addon-line" style="margin-top:30px;">
                                  <label>Event Details</label>
                                <div class="form-line">
                                  <textarea class="editor" name="details">Add Event Details here</textarea>
                                </div>
                            </div>

                            <div class="addon-line" style="margin-top:10px;">

                                <div class="form-line">
                                  <label>Notify Users</label>
                                    <select class="form-control" name="notify">
                                        <option value="0" selected>Yes</option>
                                        <option value="1">No</option>
                                    </select>
                                </div>
                            </div>



                             <?php $this->load->helper('form'); ?>
                             <div class="row">
                                 <div class="col-md-12">
                                     <?php echo validation_errors('<div class="alert alert-danger alert-dismissable">', ' <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button></div>'); ?>
                                 </div>
                             </div>
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

                            <div class="box-footer text-center">
                               <button class="btn btn-primary waves-effect" type="submit">ADD NEW EVENTS</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>
