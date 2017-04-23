<script type="text/javascript">

var selectedEmpId = "";


function resetEmployee(){
    $("#txtEmpFirstName").val("");
    $("#txtEmpLastName").val("");
    $("#txtEmpPhone").val("");
    $("#txtEmpEmail").val("");
    $("#tblEmpDetail").empty();
    $("#btnSaveEmployee").val("Save");
    selectedEmpId = "";
    searchEmployee();
}


function saveEmployee(){
    var url = "../rest/employee";
    var type = "POST";
    var data = {
            firstName : $("#txtEmpFirstName").val(),
            lastName : $("#txtEmpLastName").val(),
            email : $("#txtEmpEmail").val(),
            phone : $("#txtEmpPhone").val(),
            };
    if(selectedEmpId != ""){
        type = "PUT";
        url += "/"+selectedEmpId;
    }
    
    $.ajax({
        type : type,
        url : url,
        data : JSON.stringify(data),
        contentType: "application/json",
        success : function(data) {
             alert(data.Success);
             resetEmployee();
             searchEmployee();
        }, error : function(error){ alert(JSON.stringify(error.responseText));}
    });
    
}

function setEmployee(employeeId){
    var url = "../rest/employee/"+employeeId;
    $.get(url, function(data, status){
        selectedEmpId = employeeId;
        $("#btnSaveEmployee").val("Update");
        $("#txtEmpFirstName").val(data.firstName);
        $("#txtEmpLastName").val(data.lastName);
        $("#txtEmpEmail").val(data.email);
        $("#txtEmpPhone").val(data.phone);
    });
}

function deleteEmployee(){
    if(selectedEmpId != ""){
        $.ajax({
            type : "DELETE",
            url : '../rest/employee/'+selectedEmpId,
            success : function(data) {
                 alert(data.Success);
                 resetEmployee();
                 searchEmployee();
            }, error : function(error){ alert(error.Error); }
        });
    }
}

var tblEmpGrid;
function searchEmployee(){

    tblEmpGrid = $("#tblEmpGrid").DataTable({
        "processing": false,
        "searching": true,
        "serverSide": false,
        scrollY:   300,
        scroller:       true,
        "paging": true,
        "orderCellsTop": true,
        "destroy": true,
        dom: 'Bfrtip',
        buttons: [{
            extend: "print",
            className: "btn default"
        }, {
            extend: "pdf",
            className: "btn default"
        }, {
            extend: "csv",
            className: "btn default"
        }],
        "columns": [
            { "data": "firstName"},
            { "data": "lastName"},
            { "data": "email"},
            { "data": "phone"},
        ],
        "ajax": {
            "url": "../rest/employee?"+$("#employeeForm").serialize(),
            "type": "GET",
            "dataSrc": "[]",
            
        }
    });
}

$('#tblEmpGrid').on( 'click', 'tr', function () {
    if ( !$(this).hasClass('selected') ) {
        tblEmpGrid.$('tr.selected').removeClass('selected');
        if($(this).hasClass("odd") || $(this).hasClass("even")){
            $(this).addClass('selected');
        }
    }
});


searchEmployee();

</script>
<div class="empContainer">
    <div class="portlet light bordered">
        <div class="portlet-title">

            <div class="portlet-title">
                <div class="caption">
                    <h3 class="nomargin"><span class="caption-subject font-blue-hoki bold">Employee</span></h3>
                </div>
                <div class="actions">
                 </div>
            </div>
        </div>
        <div class="portlet-body">

            <form class="form-horizontal" id="employeeForm">
                <div class="form-body">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">First Name
                                    <span class="required" aria-required="true"> * </span>
                                </label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" placeholder="Enter Code" id="txtEmpFirstName" name="txtEmpFirstName">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Last Name
                                    <span class="required" aria-required="true"> * </span>
                                </label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" placeholder="Enter Description" id="txtEmpLastName" name="txtEmpLastName">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Email
                                    <span class="required" aria-required="true"> </span>
                                </label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" placeholder="Enter Code" id="txtEmpEmail" name="txtEmpEmail">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Phone
                                    <span class="required" aria-required="true"> </span>
                                </label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" placeholder="Enter Code" id="txtEmpPhone" name="txtEmpPhone">
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="form-actions">
                    <div class="row">
                        <div class="col-sm-offset-4 col-sm-8">
                            <button type="button" onclick="searchEmployee()" id="btnSearch" class="btn btn-primary">Search</button>
                            <button type="button" onclick="saveEmployee()" id="btnSaveEmployee" class="btn btn-primary">Save</button>
                            <button type="button" onclick="deleteEmployee()" id="btnResetType" class="btn btn-primary">Delete</button>
                            <button type="button" id="btnSearchType" onclick="resetEmployee()" class="btn btn-primary">Reset</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="portlet box green">
    <div class="portlet-title">
        <div class="caption">
            List of Employee(s) </div>
        <div class="tools"> </div>
    </div>
    <div class="portlet-body">

        <table class="table table-striped table-bordered table-hover dt-responsive" width="100%" id="tblEmpGrid" cellspacing="0" width="100%">
            <thead>
                <tr>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                </tr>
            </thead>
        </table>
    </div>
</div>