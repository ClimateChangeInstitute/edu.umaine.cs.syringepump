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
		$.getJSON("settings.json", function(data) {
			$('#loadAmountSpinner').val(data.defaultLoadAmount_ml);
			$('#unloadTimeSpinner').val(data.defaultUnloadTime_min);
			$('#loadTimeSpinner').val(data.defaultLoadTime_sec);
			$('#syringeDiameterSpinner').val(data.defaultSyringeDiameter_mm);
			$('#pitchPerRevSpinner').val(data.defaultPitch_mmPerRev);
			$('#stepsPerRevSpinner').val(data.defaultStepsPerRevolution);
		});

	};

	sp.checkLevels = function(updateTime, min, max, filling, infoType) {

		var startTime = null;
		// This function will check every
		var cls = function(max, filling) {

			if (startTime === null)
				startTime = new Date().getTime();
			$
					.ajax({
						method : "GET",
						url : "info",
						data : {
							type : infoType
						},
						success : function(data) {

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

							$('#syringeProgress').css('width', percent + '%');
							$('#syringeProgress').text(
									curVal + ' (' + percent + '%)');

							if (filling && mm < max) {
								setTimeout(cls, updateTime, max, true);
							} else if (!filling && min < mm) {
								setTimeout(cls, updateTime, max, false);
							} else {

								var diff = ((new Date().getTime() - startTime) / 1000.0);

								// Round it to nearest hundreth
								diff = Math.round(diff * 100) / 100;

								sp
										.displayMessage(
												'Syringe pump completed. The approximate amount of time the machine ran for was '
														+ diff + ' seconds.',
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
		$("#loadButton")
				.click(
						function(event) {

							// time should be in milliseconds
							$
									.ajax({
										method : "POST",
										url : "load",
										data : {
											amnt : sp
													.convertMlToMm($(
															'#loadAmountSpinner')
															.val()),
											time : $('#loadTimeSpinner').val() * 1000
										},
										success : function(data) {

											var result = $.parseJSON(data);

											sp
													.displayMessage(
															'Syringe pump started to load. Sit back and relax...',
															'info');

											sp.checkLevels(300, 0, result.amnt,
													true, "amnt");

										},
										error : function(msg) {
											sp.displayMessage(
													'Failed to start!',
													'danger');
										}
									});

						});

		// Initialize the unload button click event
		$("#unloadButton")
				.click(
						function(event) {

							$
									.ajax({
										method : "POST",
										url : "unload",
										data : {
											amnt : sp
													.convertMlToMm($(
															'#loadAmountSpinner')
															.val()),
											time : $('#unloadTimeSpinner')
													.val() * 60 * 1000
										},
										success : function(data) {

											var result = $.parseJSON(data);

											sp
													.displayMessage(
															'Syringe pump started to unload. Sit back and relax...',
															'info');

											sp.checkLevels(300, 0, result.amnt,
													false, "amnt");

										},
										error : function(msg) {
											sp.displayMessage(
													'Failed to start!',
													'danger');
										}
									});

						});

		$('#shutdownButton').click(function(event) {
			$('#shutdownModal').modal('show');
		});

		$('#shutdownConfirmButton').click(
				function(event) {

					$.ajax({
						method : "POST",
						url : "shutdown",
						success : function(data) {

							var result = $.parseJSON(data);

							sp.displayMessage(result.msg, 'success');

						},
						error : function(msg) {
							sp.displayMessage(
									'Failed to shutdown the syringe pump.',
									'danger');
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

})(sp);