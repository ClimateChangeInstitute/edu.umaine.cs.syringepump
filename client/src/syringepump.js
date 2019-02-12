// @ts-check

import "bootstrap/dist/css/bootstrap.css";
import "./site.css";
import "./favicon.ico";

import "bootstrap";
import bootbox from "bootbox";
import $ from "jquery";

class MessageType {
  /**
   *
   * @param {string} val
   */
  constructor(val) {
    this.val = val;
  }
  toString() {
    return this.val;
  }
}
export const Message = {
  DANGER: new MessageType("danger"),
  INFO: new MessageType("info"),
  SUCCESS: new MessageType("success"),
  WARNING: new MessageType("warning")
};

/**
 * Display a message to the #syringeStatus bar.
 *
 * @param {string} message
 *            Message to display
 * @param {MessageType} type
 *            info, success, warning, danger
 */
export function displayMessage(message, type) {
  $("#syringeStatus").removeClass();
  $("#syringeStatus").addClass("alert alert-" + type);
  $("#syringeStatus").text(message);
}

/**
 *
 * @param {number} diameter
 * @param {number} pitchPerRev
 * @param {number} stepsPerRev
 */
export function calculateStepsPerMl(diameter, pitchPerRev, stepsPerRev) {
  var r = diameter / 2.0;
  var mlPerRev = ((3.14159 * r * r) / 1000.0) * pitchPerRev;

  return Math.round(stepsPerRev / mlPerRev);
}

/**
 *
 * @param {number} mlAmnt
 */
export function convertMlToMm(mlAmnt) {
  // Result should be in millimeters
  // mm = mlAmnt * stepsPerMl * pitchPerRev / stepsPerRev

  // Syringe radius
  var r = Number($("#syringeDiameterSpinner").val()) / 2.0;
  var mlPerRev = 3.14159 * r * r * Number($("#pitchPerRevSpinner").val());

  var mm = (mlAmnt / mlPerRev) * Number($("#pitchPerRevSpinner").val()) * 1000;

  return mm;
}

/**
 *
 * @param {number} mmAmnt
 */
export function convertMmToMl(mmAmnt) {
  // Result should be in milliliters
  // mm = mmAmnt / pitchPerRev * stepsPerRev / stepsPerMl

  // Syringe radius
  var r = Number($("#syringeDiameterSpinner").val()) / 2.0;
  var mlPerRev = 3.14159 * r * r * Number($("#pitchPerRevSpinner").val());

  var ml =
    ((mmAmnt / Number($("#pitchPerRevSpinner").val())) * mlPerRev) / 1000.0;

  return ml;
}

/**
 * @param updateTime
 *            {number} How frequently to poll for info
 * @param start_ml
 *            {number} The starting amount of ml
 * @param min
 *            {number}
 * @param max
 *            {number}
 * @param filling
 *            {boolean}
 * @param infoType
 *            {string} amnt or steps
 */
export function checkLevels(updateTime, start_ml, min, max, filling, infoType) {
  var startTime = null;
  // This function will check every
  var cls = function(max, filling) {
    if (startTime === null) startTime = new Date().getTime();

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
        if (infoType === "amnt") curVal = convertMmToMl(mm);

        // Round to nearest tenth
        mm = +mm.toFixed(1);
        curVal = +curVal.toFixed(1);
        var maxVal = max - min;
        if (infoType === "amnt") maxVal = +convertMmToMl(max).toFixed(1);
        var percent = +((curVal / maxVal) * 100).toFixed(1);

        // Also round stopping conditions
        min = +min.toFixed(1);
        max = +max.toFixed(1);

        $("#syringeProgress").css("width", percent + "%");
        $("#syringeProgress").text(curVal + " (" + percent + "%)");

        if (infoType != "steps") {
          if (filling) {
            $("#currentLoadAmount").val(start_ml + curVal);
          } else {
            $("#currentLoadAmount").val(curVal);
          }
        }

        if (filling && mm < max) {
          if (infoType === "amnt" && !result.isRunning) {
            displayMessage("Syringe pump stopped", Message.DANGER);
            return; // Stop polling
          }
          setTimeout(cls, updateTime, max, true);
        } else if (!filling && min < mm) {
          if (infoType === "amnt" && !result.isRunning) {
            displayMessage("Syringe pump stopped", Message.DANGER);
            return; // Stop polling
          }
          setTimeout(cls, updateTime, max, false);
        } else {
          var diff = (new Date().getTime() - startTime) / 1000.0;

          // Round it to nearest hundreth
          diff = Math.round(diff * 100) / 100;

          displayMessage(
            "Syringe pump completed. The approximate amount of time the machine ran for was " +
              diff +
              " seconds.",
            Message.SUCCESS
          );

          startTime = null;
        }
      }
    });
  };
  // Start checking levels!
  cls(max, filling);
}

var theModals = {};

// Any element containing Bootbox.js data name
$(document).on("click", "[data-bb]", function(e) {
  e.preventDefault();
  var type = $(this).data("bb");

  if (typeof theModals[type] === "function") {
    theModals[type]();
  }
});

var $modalContent = $("#modals");

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

              displayMessage(result.msg, Message.SUCCESS);
            },
            error: function(msg) {
              displayMessage(
                `Failed to shutdown the syringe pump. Reason: ${msg}`,
                Message.DANGER
              );
            }
          });
        }
      }
    }
  });
};

$(document).ready(function() {
  $("[data-toggle=\"tooltip\"]").tooltip();
  $("body").fadeIn(500);
});
