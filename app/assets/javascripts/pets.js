/* global $ */
//Document ready.
$(document).on('turbolinks:load', function(){
    var theForm = $('#pet_form');
    var submitBtn = $('#form-signup-btn');
    
    submitBtn.click(function(event){
        //prevent default submission behavior.
        event.preventDefault();
        submitBtn.val("Processing").prop('disabled', true);
        
        //Collect the form fields.
        var uft = $('#pet_uft').is(':checked'),
            ufa = $('#pet_ufa').is(':checked');
            
        var error = false;
        
        if(uft == false && ufa == false) {
            error = true;
            alert('You must select UFT or UFA');
        }

        if (error) {
            submitBtn.prop('disabled', false).val("Submit Pet");
        }
        else {
            //Submit the form
            theForm.submit();
        }
    });
    
    return false;
    
});