
<!-- Jquery Core Js -->
<script src="<?php echo asset_url('plugins/jquery/jquery.min.js') ?>"></script>

<!-- Bootstrap Core Js -->
<script src="<?php echo asset_url('plugins/bootstrap/js/bootstrap.js') ?>"></script>
<!-- Select Plugin Js -->
<script src="<?php echo asset_url('plugins/bootstrap-select/js/bootstrap-select.js') ?>"></script>
<!-- Waves Effect Plugin Js -->
<script src="<?php echo asset_url('plugins/jquery-slimscroll/jquery.slimscroll.js') ?>"></script>
<!-- Custom Js -->
<script src="<?php echo asset_url('js/admin.js') ?>"></script>
<!-- Demo Js -->
<script src="<?php echo asset_url('js/demo.js') ?>"></script>

<!--THIS PAGE LEVEL JS-->
<script src="<?php echo asset_url('plugins/jquery-datatable/jquery.dataTables.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/skin/bootstrap/js/dataTables.bootstrap.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/dataTables.buttons.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/buttons.flash.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/jszip.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/pdfmake.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/vfs_fonts.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/buttons.html5.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/buttons.print.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/dataTables.keyTable.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/dataTables.responsive.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/responsive.bootstrap.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/dataTables.scroller.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-datatable/extensions/export/dataTables.fixedHeader.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/jquery-slimscroll/jquery.slimscroll.js') ?>"></script>
<script src="<?php echo asset_url('js/pages/tables/jquery-datatable.js') ?>"></script>
<script src="<?php echo asset_url('plugins/bootstrap-notify/bootstrap-notify.js') ?>"></script>
<script src="<?php echo asset_url('plugins/sweetalert/sweetalert.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/bootstrap-notify/bootstrap-notify.js') ?>"></script>
<script src="<?php echo asset_url('plugins/bootstrap-select/js/bootstrap-select.js') ?>"></script>
<script src="<?php echo asset_url('plugins/dropify/dist/js/dropify.min.js') ?>"></script>
<script src="<?php echo asset_url('plugins/momentjs/moment.js') ?>"></script>
<script src="<?php echo asset_url('plugins/bootstrap-material-datetimepicker/js/bootstrap-material-datetimepicker.js') ?>"></script>
<script src="<?php echo asset_url('plugins/bootstrap-daterange/daterangepicker.js') ?>"></script>
<!-- LAYOUT JS -->
<script src="<?php echo asset_url('js/ajax.js') ?>"></script>
<script>
tinymce.init({
    selector: ".editor1",
    theme: "modern",
    height: 100,
    inline_styles : true,
    valid_elements : '*[*]',
    plugins: [
        'advlist autolink lists link image charmap print preview hr anchor pagebreak',
        'searchreplace wordcount visualblocks visualchars code fullscreen',
        'insertdatetime media nonbreaking save table contextmenu directionality',
        'emoticons template paste textcolor colorpicker textpattern imagetools'
    ],
    toolbar1: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
    toolbar2: 'print preview media | forecolor backcolor emoticons',
    image_advtab: true
});
tinymce.init({
    selector: ".editor",
    theme: "modern",
    height: 300,
    inline_styles : true,
    valid_elements : '*[*]',
    plugins: [
        'advlist autolink lists link image charmap print preview hr anchor pagebreak',
        'searchreplace wordcount visualblocks visualchars code fullscreen',
        'insertdatetime media nonbreaking save table contextmenu directionality',
        'emoticons template paste textcolor colorpicker textpattern imagetools'
    ],
    toolbar1: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
    toolbar2: 'print preview media | forecolor backcolor emoticons',
    image_advtab: true
});
$(function() {
    if(document.getElementById('reportrange')==undefined)return;
    var date = document.getElementById('reportrange').value;
    var res = date.split(" - ");
    var start = 0;
    var end = 0;
    if(res[0] != undefined && res[1] != undefined){
       start = res[0];
       end = res[1];
    }else{
      start = (moment().subtract(0, 'days')).format('YYYY-MM-DD');
      end = (moment()).format('YYYY-MM-DD');
    }

    function cb(start, end) {
        $('#reportrange span').html(start + ' - ' + end);
    }

    $('#reportrange').daterangepicker({
        startDate: start,
        endDate: end,
        locale: {
          format: 'YYYY-MM-DD'
        },
        ranges: {
           'Today': [moment(), moment()],
           'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
           'Last 7 Days': [moment().subtract(6, 'days'), moment()],
           'Last 30 Days': [moment().subtract(29, 'days'), moment()],
           'This Month': [moment().startOf('month'), moment().endOf('month')],
           'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        }
    }, cb);

    cb(start, end);

});
</script>
<script src="<?php echo asset_url('js/common.js') ?>"></script>
</body>

</html>
