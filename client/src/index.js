// @ts-check

import $ from "jquery";
import bootbox from "bootbox";

import * as sp from "./syringepump";

function setupDefaultValues() {
  // Initialize spinner default values
  $.getJSON("defaults?action=load", function(data) {
    $("#loadAmountSpinner").val(data.defaultLoadAmount_ml);
    $("#unloadTimeSpinner").val(data.defaultUnloadTime_min);
    $("#loadTimeSpinner").val(data.defaultLoadTime_sec);
    $("#syringeDiameterSpinner").val(data.defaultSyringeDiameter_mm);
    $("#pitchPerRevSpinner").val(data.defaultPitch_mmPerRev);
    $("#stepsPerRevSpinner").val(data.defaultStepsPerRevolution);
  });
}

/**
 *
 * @param {JQuery.MouseEventBase} event
 */
// eslint-disable-next-line no-unused-vars
function loadButtonClicked(event) {
  $.ajax({
    method: "GET",
    url: "info",
    data: {
      type: "amnt"
    },
    success: function(data) {
      var fr = $.parseJSON(data);

      if (fr.isRunning) {
        bootbox.alert(
          "Syringe currently running. Please cancel the current operation by clicking the stop button.",
          // eslint-disable-next-line no-unused-vars
          function(result) {}
        );
        return;
      }

      // time should be in milliseconds
      $.ajax({
        method: "POST",
        url: "load",
        data: {
          amnt: sp.convertMlToMm(Number($("#loadAmountSpinner").val())),
          time: Number($("#loadTimeSpinner").val()) * 1000
        },
        success: function(data) {
          var result = $.parseJSON(data);

          sp.displayMessage(
            "Syringe pump started to load " +
              $("#loadAmountSpinner").val() +
              "ml. Sit back and relax...",
            sp.Message.INFO
          );

          sp.checkLevels(
            300,
            Number($("#currentLoadAmount").val()),
            0,
            result.amnt,
            true,
            "amnt"
          );
        },
        error: function(msg) {
          sp.displayMessage(
            `Failed to start. Reason: ${msg}`,
            sp.Message.DANGER
          );
        }
      });
    },
    error: function(msg) {
      console.log(`Unable to get motor info. Reason: ${msg}`);
    }
  });
}

/**
 *
 * @param {JQuery.MouseEventBase} event
 */
// eslint-disable-next-line no-unused-vars
function unloadButtonClicked(event) {
  $.ajax({
    method: "GET",
    url: "info",
    data: {
      type: "amnt"
    },
    success: function(data) {
      var fr = $.parseJSON(data);

      if (fr.isRunning) {
        bootbox.alert(
          "Syringe currently running. Please cancel the current operation by clicking the stop button.",
          // eslint-disable-next-line no-unused-vars
          function(result) {}
        );
        return;
      }

      var toUnloadAmnt = Number(
        // $("#syringeProgress")
        //   .text()
        //   .split("(")[0]
        $("#currentLoadAmount").val()
      );

      // Only unload specified amount if smaller
      // if (toUnloadAmnt > Number($("#loadAmountSpinner").val())) {
      //   toUnloadAmnt = Number($("#loadAmountSpinner").val());
      // }

      $.ajax({
        method: "POST",
        url: "unload",
        data: {
          amnt: sp.convertMlToMm(toUnloadAmnt),
          time: Number($("#unloadTimeSpinner").val()) * 60 * 1000
        },
        success: function(data) {
          var result = $.parseJSON(data);

          sp.displayMessage(
            "Syringe pump started to unload " +
              toUnloadAmnt +
              "ml. Sit back and relax...",
            sp.Message.INFO
          );

          sp.checkLevels(
            300,
            Number($("#currentLoadAmount").val()),
            0,
            result.amnt,
            false,
            "amnt"
          );
        },
        error: function(msg) {
          sp.displayMessage(
            `Failed to start. Reason: ${msg}`,
            sp.Message.DANGER
          );
        }
      });
    },
    error: function(msg) {
      console.log(`Unable to get motor info. Reason: ${msg}`);
    }
  });
}

/**
 *
 * @param {JQuery.MouseEventBase} event
 */
// eslint-disable-next-line no-unused-vars
function stopMotorButtonClicked(event) {
  $.ajax({
    method: "POST",
    url: "cancel",
    data: {
      /* No Data */
    },
    // eslint-disable-next-line no-unused-vars
    success: function(data) {
      sp.displayMessage("Motor operation canceled.", sp.Message.INFO);
    },
    error: function(msg) {
      console.log(msg);
      console.log(`Failed to cancel the motor. Reason: ${msg.statusText}`);
    }
  });
}

function saveDefaultSettingsButtonClicked() {
  var defaultLoadAmnt_ml = $("#loadAmountSpinner").val();
  var defaultLoadTime_sec = $("#loadTimeSpinner").val();
  var defaultPitch_mmPerRev = $("#pitchPerRevSpinner").val();
  var defaultStepsPerRevolution = $("#stepsPerRevSpinner").val();
  var defaultSyringeDiameter_mm = $("#syringeDiameterSpinner").val();
  var defaultUnloadTime_min = $("#unloadTimeSpinner").val();

  bootbox.confirm(
    "Are you sure you want to save values as default settings?",
    function(result) {
      if (result) {
        $.ajax({
          method: "POST",
          url: "defaults",
          data: {
            action: "save",
            vals: {
              defaultLoadAmount_ml: defaultLoadAmnt_ml,
              defaultLoadTime_sec: defaultLoadTime_sec,
              defaultPitch_mmPerRev: defaultPitch_mmPerRev,
              defaultStepsPerRevolution: defaultStepsPerRevolution,
              defaultSyringeDiameter_mm: defaultSyringeDiameter_mm,
              defaultUnloadTime_min: defaultUnloadTime_min
            }
          },
          success: function(data) {
            $("#stepsPerMlSpan").html(
              sp
                .calculateStepsPerMl(
                  Number($("#syringeDiameterSpinner").val()),
                  Number($("#pitchPerRevSpinner").val()),
                  Number($("#stepsPerRevSpinner").val())
                )
                .toString()
            );

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
              message: `Hmm... something went wrong. Reason: ${data}`,
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
    }
  );
}

function setupPushButtons() {
  // Initialize the load button click event
  $("#loadButton").click(loadButtonClicked);

  // Initialize the unload button click event
  $("#unloadButton").click(unloadButtonClicked);

  $("#stopMotorButton").click(stopMotorButtonClicked);

  $("#saveDefaultSettingsButton").click(saveDefaultSettingsButtonClicked);

  initStepButton("motorStepBackward", -2000);
  initStepButton("motorFastBackward", -1000);
  initStepButton("motorBackward", -100);
  initStepButton("motorForward", 100);
  initStepButton("motorFastForward", 1000);
  initStepButton("motorStepForward", 2000);

  // Initially hide the advanced features...
  $("#advancedFeaturesContent").hide();
  $("#advancedFeatures").click(function() {
    $("#advancedFeaturesContent").toggle();
  });
}

/**
 *
 * @param {string} buttonName The id of the button
 * @param {number} loadSteps The number of steps to move the number.  May be negative to indicate the opposite direction.
 */
function initStepButton(buttonName, loadSteps) {
  // Initialize the load button click event
  // eslint-disable-next-line no-unused-vars
  $("#" + buttonName).click(function(event) {
    $.ajax({
      method: "GET",
      url: "info",
      data: {
        type: "amnt"
      },
      success: function(data) {
        var fr = $.parseJSON(data);

        if (fr.isRunning) {
          bootbox.alert(
            "Syringe currently running. Please cancel the current operation by clicking the stop button.",
            // eslint-disable-next-line no-unused-vars
            function(result) {}
          );
          return;
        }

        // time should be in milliseconds
        $.ajax({
          method: "POST",
          url: "moveSteps",
          data: {
            steps: loadSteps,
            time_ms: Math.abs(loadSteps * 5)
          },
          success: function(data) {
            sp.displayMessage(
              "Moving motor " + loadSteps + " steps",
              sp.Message.INFO
            );

            var result = $.parseJSON(data);

            var min = result.start;
            var max = result.end;
            if (result.end < result.start) {
              min = result.end;
              max = result.start;
            }

            console.log(min + " " + max);

            sp.checkLevels(
              300,
              Number($("#currentLoadAmount").val()),
              min,
              max,
              result.start < result.end,
              "steps"
            );
          },
          error: function(msg) {
            console.log(`Failed to move motor. Reason: ${msg}`);
          }
        });
      },
      error: function(msg) {
        console.log(`Unable to get motor info. Reason: ${msg}`);
      }
    });
  });
}

$(document).ready(function() {
  $("#homeNav").addClass("active");

  setupDefaultValues();

  setupPushButtons();

  $("#stepsPerMlSpan").html(
    sp
      .calculateStepsPerMl(
        Number($("#syringeDiameterSpinner").val()),
        Number($("#pitchPerRevSpinner").val()),
        Number($("#stepsPerRevSpinner").val())
      )
      .toString()
  );

  // 			$('#motorReset').click(function(event) {
  // 				// time should be in milliseconds
  // 				$.ajax({
  // 					method : "POST",
  // 					url : "reset",
  // 					data : { /* No Data */
  // 					},
  // 					success : function(data) {
  // 						sp.displayMessage("Motor position reset to 0.", 'info');
  // 					},
  // 					error : function(msg) {
  // 						console.log('Failed to reset');
  // 					}
  // 				});
  //
  // 			});
});
