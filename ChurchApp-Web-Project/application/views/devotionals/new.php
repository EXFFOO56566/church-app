<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Add New Devotional</h2>
        </div>


            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>saveNewDevotional" enctype="multipart/form-data" style="margin-top:30px;">

                            <div class="input-group addon-line" style="margin-top:20px;">
                                  <label>Devotional Date</label>
                                <div class="form-line">
                                    <input type="date" class="form-control" name="date" placeholder="Devotional Date" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Devotional CoverPhoto (Leave empty to use app default image)</label>
                                <div class="form-line">
                                    <input type="file" name="thumbnail" data-allowed-file-extensions="png jpg jpeg PNG" class="thumbs_dropify">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                 <label>Devotional Writer/Author</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="author" placeholder="Devotional Writer/Author" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                 <label>Devotional Title</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" placeholder="Devotional Title" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:30px;">
                                  <label>Devotional Bible Reading/Text</label>
                                <div class="form-line">
                                  <textarea class="editor1" name="bible_reading">Add Devotional Bible Text Here</textarea>
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:30px;">
                                  <label>Devotional Content</label>
                                <div class="form-line">
                                  <textarea class="editor" name="content">Add Devotional Content Here</textarea>
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:30px;">
                                  <label>Devotional Confession/Thought of the day</label>
                                <div class="form-line">
                                  <textarea class="editor1" name="confession">Add Devotional Confession or Thought of the day</textarea>
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:30px;">
                                  <label>Further Bible Readings</label>
                                <div class="form-line">
                                  <textarea class="editor1" name="studies">Add Further Bible Readings</textarea>
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
                               <button class="btn btn-primary waves-effect" type="submit">SAVE</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>
