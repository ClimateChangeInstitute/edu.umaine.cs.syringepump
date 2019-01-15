/**
 * @fileOverview This file contains the syringe pump functions.
 * @author Mark Royer
 */

/** @namespace syringe pump name space */
var sp = {};

(function(sp) {

    /**
     * @param message
     *            Message to display
     * @param type
     *            info, success, warning, danger
     */
    sp.displayMessage = function(message, type) {
        $('#syringeStatus').removeClass();
        $('#syringeStatus').addClass('alert alert-' + type);
        $('#syringeStatus').text(message);
    };

    sp.calculateStepsPerMl = function(diameter, pitchPerRev, stepsPerRev) {
        var r = diameter / 2.0;
        var mlPerRev = 3.14159 * r * r / 1000.0 * pitchPerRev;

        return Math.round(stepsPerRev / mlPerRev);
    };

    sp.convertMlToMm = function(mlAmnt) {
        // Result should be in millimeters
        // mm = mlAmnt * stepsPerMl * pitchPerRev / stepsPerRev

        // Syringe radius
        var r = $('#syringeDiameterSpinner').val() / 2.0;
        var mlPerRev = 3.14159 * r * r * $('#pitchPerRevSpinner').val();

        var mm = mlAmnt / mlPerRev * $('#pitchPerRevSpinner').val() * 1000;

        return mm;
    };

    sp.convertMmToMl = function(mmAmnt) {
        // Result should be in milliliters
        // mm = mmAmnt / pitchPerRev * stepsPerRev / stepsPerMl

        // Syringe radius
        var r = $('#syringeDiameterSpinner').val() / 2.0;
        var mlPerRev = 3.14159 * r * r * $('#pitchPerRevSpinner').val();

        var ml = mmAmnt / $('#pitchPerRevSpinner').val() * mlPerRev / 1000.0;

        return ml;
    };

    sp.setupDefaultValues = function() {

        // Initialize spinner default values
        $.getJSON("defaults?action=load", function(data) {
            $('#loadAmountSpinner').val(data.defaultLoadAmount_ml);
            $('#unloadTimeSpinner').val(data.defaultUnloadTime_min);
            $('#loadTimeSpinner').val(data.defaultLoadTime_sec);
            $('#syringeDiameterSpinner').val(data.defaultSyringeDiameter_mm);
            $('#pitchPerRevSpinner').val(data.defaultPitch_mmPerRev);
            $('#stepsPerRevSpinner').val(data.defaultStepsPerRevolution);
        });

    };

    /**
     * @param updateTime
     *            {number} How frequently to poll for info
     * @param min
     *            {number}
     * @param max
     *            {number}
     * @param filling
     *            {boolean}
     * @param infoType
     *            {string} amnt or steps
     */
    sp.checkLevels = function(updateTime, min, max, filling, infoType) {

        var startTime = null;
        // This function will check every
        var cls = function(max, filling) {

            if (startTime === null)
                startTime = new Date().getTime();

            $.ajax({
                method: "GET",
                url: "info",
                data: {
                    type: infoType
                },
                success: function(data) {

                    var result = $.parseJSON(data);

                    var mm = result[infoType];
                    var curVal = mm - min;
                    if (infoType === "amnt")
                        curVal = sp.convertMmToMl(mm);

                    // Round to nearest tenth
                    mm = +mm.toFixed(1);
                    curVal = +curVal.toFixed(1);
                    var maxVal = max - min;
                    if (infoType === "amnt")
                        maxVal = +sp.convertMmToMl(max).toFixed(1);
                    var percent = +(curVal / maxVal * 100).toFixed(1);

                    // Also round stopping conditions
                    min = +min.toFixed(1);
                    max = +max.toFixed(1);

                    $('#syringeProgress').css('width', percent + '%');
                    $('#syringeProgress').text(
                        curVal + ' (' + percent + '%)');

                    if (filling && mm < max) {
                        if (infoType === "amnt" && !result['isRunning']) {
                            sp
                                .displayMessage(
                                    'Syringe pump stopped',
                                    'danger');
                            return; // Stop polling
                        }
                        setTimeout(cls, updateTime, max, true);
                    } else if (!filling && min < mm) {
                        if (infoType === "amnt" && !result['isRunning']) {
                            sp
                                .displayMessage(
                                    'Syringe pump stopped',
                                    'danger');
                            return; // Stop polling
                        }
                        setTimeout(cls, updateTime, max, false);
                    } else {

                        var diff = ((new Date().getTime() - startTime) / 1000.0);

                        // Round it to nearest hundreth
                        diff = Math.round(diff * 100) / 100;

                        sp
                            .displayMessage(
                                'Syringe pump completed. The approximate amount of time the machine ran for was ' +
                                diff + ' seconds.',
                                'success');

                        startTime = null;

                    }
                }
            });

        }
        // Start checking levels!
        cls(max, filling);
    };

    sp.setupPushButtons = function() {

        // Initialize the load button click event
        $("#loadButton").click(
            function(event) {


                $.ajax({
                    method: "GET",
                    url: "info",
                    data: {
                        type: 'amnt'
                    },
                    success: function(data) {


                        var fr = $.parseJSON(data);

                        if (fr['isRunning']) {

                            bootbox.alert("Syringe currently running. Please cancel the current operation by clicking the stop button.",
                                function(result) {});
                            return;

                        }

                        // time should be in milliseconds
                        $
                            .ajax({
                                method: "POST",
                                url: "load",
                                data: {
                                    amnt: sp
                                        .convertMlToMm($(
                                                '#loadAmountSpinner')
                                            .val()),
                                    time: $('#loadTimeSpinner').val() * 1000
                                },
                                success: function(data) {

                                    var result = $.parseJSON(data);

                                    sp
                                        .displayMessage(
                                            'Syringe pump started to load ' + $('#loadAmountSpinner')
                                            .val() + 'ml. Sit back and relax...',
                                            'info');

                                    sp.checkLevels(300, 0, result.amnt,
                                        true, "amnt");

                                },
                                error: function(msg) {
                                    sp.displayMessage(
                                        'Failed to start!',
                                        'danger');
                                }
                            });

                    },
                    error: function(msg) {
                        console.log('Unable to get motor info!');
                    }
                });

            });

        // Initialize the unload button click event
        $("#unloadButton").click(
            function(event) {


                $.ajax({
                    method: "GET",
                    url: "info",
                    data: {
                        type: 'amnt'
                    },
                    success: function(data) {


                        var fr = $.parseJSON(data);

                        if (fr['isRunning']) {

                            bootbox.alert("Syringe currently running. Please cancel the current operation by clicking the stop button.",
                                function(result) {});
                            return;

                        }

                        var toUnloadAmnt = new Number($('#syringeProgress').text().split('(')[0]);

                        // Only unload specified amount if smaller
                        if (toUnloadAmnt > $('#loadAmountSpinner').val()) {
                            toUnloadAmnt = $('#loadAmountSpinner').val();
                        }

                        $
                            .ajax({
                                method: "POST",
                                url: "unload",
                                data: {
                                    amnt: sp
                                        .convertMlToMm(toUnloadAmnt),
                                    time: $('#unloadTimeSpinner')
                                        .val() * 60 * 1000
                                },
                                success: function(data) {

                                    var result = $.parseJSON(data);

                                    sp
                                        .displayMessage(
                                            'Syringe pump started to unload ' + toUnloadAmnt + 'ml. Sit back and relax...',
                                            'info');

                                    sp.checkLevels(300, 0, result.amnt,
                                        false, "amnt");

                                },
                                error: function(msg) {
                                    sp.displayMessage(
                                        'Failed to start!',
                                        'danger');
                                }
                            });

                    },
                    error: function(msg) {
                        console.log('Unable to get motor info!');
                    }
                });


            });

    };

    sp.setupAdvancedFeaturesButton = function() {

        // Initially hide the advanced features...
        $('#advancedFeaturesContent').hide();
        $('#advancedFeatures').click(function() {
            $('#advancedFeaturesContent').toggle();
        })

    };

    $('#saveDefaultSettingsButton').click(
        function() {

            var defaultLoadAmnt_ml = $('#loadAmountSpinner').val();
            var defaultLoadTime_sec = $('#loadTimeSpinner').val();
            var defaultPitch_mmPerRev = $('#pitchPerRevSpinner').val();
            var defaultStepsPerRevolution = $('#stepsPerRevSpinner').val();
            var defaultSyringeDiameter_mm = $('#syringeDiameterSpinner').val();
            var defaultUnloadTime_min = $('#unloadTimeSpinner').val();

            bootbox.confirm("Are you sure you want to save values as default settings?", function(result) {
                if (result) {
                    $.ajax({
                        method: "POST",
                        url: "defaults",
                        data: {
                            action: 'save',
                            vals: {
                                "defaultLoadAmount_ml": defaultLoadAmnt_ml,
                                "defaultLoadTime_sec": defaultLoadTime_sec,
                                "defaultPitch_mmPerRev": defaultPitch_mmPerRev,
                                "defaultStepsPerRevolution": defaultStepsPerRevolution,
                                "defaultSyringeDiameter_mm": defaultSyringeDiameter_mm,
                                "defaultUnloadTime_min": defaultUnloadTime_min
                            }
                        },
                        success: function(data) {

                            $('#stepsPerMlSpan').html(sp.calculateStepsPerMl(
                                $('#syringeDiameterSpinner').val(),
                                $('#pitchPerRevSpinner').val(),
                                $('#stepsPerRevSpinner').val()));

                            var $data = $.parseJSON(data);
                            bootbox.dialog({
                                title: "Default Settings Saved",
                                message: $data.msg,
                                onEscape: function() {
                                    /* Do nothing */
                                },
                                backdrop: true
                            });
                        },
                        error: function(data) {
                            bootbox.dialog({
                                title: "Failed Saving",
                                message: "Hmm... something went wrong.",
                                onEscape: function() {
                                    /*
                                     * Do nothing
                                     */
                                },
                                backdrop: true
                            });
                        }
                    });
                }
            });

        });


    $.get("modals.html", function(data) {
        var theModals = {};

        // Any element containing Bootbox.js data name
        $(document).on("click", "[data-bb]", function(e) {
            e.preventDefault();
            var type = $(this).data("bb");

            if (typeof theModals[type] === 'function') {
                theModals[type]();
            }
        });

        var $modalContent = $(data);

        theModals.about = function() {
            bootbox.dialog({
                title: "About",
                message: $modalContent.find("#aboutDialogContent").html(),
                onEscape: function() {
                    /* Do nothing */
                },
                backdrop: true

            });
        };

        theModals.contact = function() {
            bootbox.dialog({
                title: "Contact",
                message: $modalContent.find("#contactDialogContent").html(),
                onEscape: function() {
                    /* Do nothing */
                },
                backdrop: true
            });
        };

        theModals.shutdown = function() {
            bootbox.dialog({
                title: "Shutdown Pump?",
                message: $modalContent.find("#shutdownDialogContent").html(),
                onEscape: function() {
                    /* Do nothing */
                },
                backdrop: true,
                buttons: {
                    cancel: {
                        label: "Cancel",
                        className: "btn-default",
                        callback: function() {
                            /* Do nothing */
                        }
                    },
                    ok: {
                        label: "OK",
                        className: "btn-primary",
                        callback: function() {
                            $.ajax({
                                method: "POST",
                                url: "shutdown",
                                success: function(data) {

                                    var result = $.parseJSON(data);

                                    sp.displayMessage(result.msg, 'success');

                                },
                                error: function(msg) {
                                    sp.displayMessage(
                                        'Failed to shutdown the syringe pump.',
                                        'danger');
                                }
                            });
                        }
                    }
                }
            });
        };

    });


})(sp);