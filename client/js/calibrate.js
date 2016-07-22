/**
 * 
 */

var calibrationSetup = function() {

	$("#header").load("header.html", function() {
		$("#calNav").addClass("active");
	});

	$('#rootwizard').bootstrapWizard(
			{
				'tabClass' : 'nav nav-tabs',
				'onNext' : function(evt) {
					// Do nothing...
				},
				'onLast' : function(evt) {
					// Do nothing...
				},
				'onTabShow' : function(tab, navigation, index) {
					var $total = navigation.find('li').length;
					var $current = index + 1;
					var $percent = ($current / $total) * 100;
					$('#rootwizard').find('.bar').css({
						width : $percent + '%'
					});

					// If it's the last tab then hide the next button and show
					// the save
					// instead
					if ($current >= $total) {
						$('#rootwizard').find('.pager .next').hide();
						$('#rootwizard').find('.pager .finish').show();
						$('#rootwizard').find('.pager .finish').removeClass(
								'disabled');

						// Make sure final values match
						$('#input1kFinal').val($('#input1k').val());
						$('#input2kFinal').val($('#input2k').val());
						$('#input4kFinal').val($('#input4k').val());

					} else {
						$('#rootwizard').find('.pager .next').show();
						$('#rootwizard').find('.pager .finish').hide();
					}
				}
			});
	$('#rootwizard .finish').click(
			function() {

				var v1 = parseFloat($('#input1kFinal').val());
				var v2 = parseFloat($('#input2kFinal').val());
				var v3 = parseFloat($('#input4kFinal').val());

				// *************************************************
				// START calculate linear regression of three values
				// *************************************************

				var xMean = (1000 + 2000 + 4000) / 3.0;
				var yMean = (v1 + v2 + v3) / 3.0;

				var mTop = (1000 - xMean) * (v1 - yMean) + (2000 - xMean)
						* (v2 - yMean) + (4000 - xMean) * (v3 - yMean);
				var mBottom = (1000 - xMean) * (1000 - xMean) + (2000 - xMean)
						* (2000 - xMean) + (4000 - xMean) * (4000 - xMean);
				var m = mTop / mBottom; // ml per step
				var b = yMean - m * xMean;

				// *************************************************
				// END calculate linear regression of three values
				// *************************************************

				// Values that need to be retrieved

				// Get default values and ask for update confirmation
				$.getJSON("defaults?action=load", function(data) {
					var defaultLoadAmnt_ml = data.defaultLoadAmount_ml;
					var defaultUnloadTime_min = data.defaultUnloadTime_min;
					var defaultLoadTime_sec = data.defaultLoadTime_sec;

					var currentDiameter = data.defaultSyringeDiameter_mm;
					var stepsPerRev = data.defaultStepsPerRevolution;
					var currentPitch = data.defaultPitch_mmPerRev;

					// 1000 cubic mm per 1 ml
					var mm3PerMl = 1000;
					var r = currentDiameter / 2.0;

					// Calculate the new values

					var newPitch = m * mm3PerMl / (3.14159 * r * r)
							* stepsPerRev;
					var newDiameter = 2 * Math.sqrt(m * mm3PerMl * stepsPerRev
							/ (3.14159 * currentPitch));

					// We'll ignore the newPitch and just use the newDiameter
					// for now
					
					var stepsPerMl = sp.calculateStepsPerMl(
							newDiameter,
							currentPitch,
							stepsPerRev);
					
					bootbox.confirm("Are you sure you want to save the new calibration settings? " +
							"The new number of steps per 1 ml will be " + stepsPerMl + ".", function(result) {
						  if (result) {
							  $.ajax({
									method : "POST",
									url : "defaults",
									data : {
										action : 'save',
										vals : {
											'defaultSyringeDiameter_mm' : newDiameter
										}
									},
									success : function(data) {
										var $data = $.parseJSON(data);
										bootbox.dialog({
											title: "Calibration Saved",
										    message: $data.msg,
										    onEscape: function() { 
										    	// Redirect back to main page
										    	window.location.href = "index.html";
										    },
										    backdrop: true
										});
									},
									error : function(data) {
										bootbox.dialog({
											title: "Failed Saving",
										    message: "Hmm... something went wrong.",
										    onEscape: function() { /*
																	 * Do
																	 * nothing
																	 */ },
										    backdrop: true
										});
									}
								});
						  }
						}); 
					
				});

			});

	// Initialize the load and unload button click events

	var initLoadAndUnloadEvents = function(buttonName, loadSteps, isLoad) {
		$('#' + buttonName)
				.click(
						function(event) {

							$('#' + buttonName).attr('data-steps', loadSteps);

							console.log("Number of steps " + loadSteps);

							// time should be in milliseconds
							$
									.ajax({
										method : "POST",
										url : "moveSteps",
										data : {
											steps : loadSteps,
											time_ms : Math.abs(loadSteps * 5) 
										},
										success : function(data) {

											var result = $.parseJSON(data);

											sp
													.displayMessage(
															'Syringe pump started to load. Sit back and relax...',
															'info');

											var min = result.start;
											var max = result.end;
											if (result.end < result.start) {
												min = result.end;
												max = result.start;
											}

											console.log(min + " " + max);

											sp.checkLevels(300, min, max,
													isLoad, "steps");

										},
										error : function(msg) {
											console.log('Failed to start!');
										}
									});

						});

	}

	var tabInit = function(tabName, loadName, loadSteps, unloadName,
			unloadSteps, defaultMl, inputId) {
		$('#' + tabName).load("calibrateStep.html", function() {
			var buttons = $(this).find('button');
			var stepLoad = $(buttons[0]);
			stepLoad.attr('id', loadName);
			var stepUnload = $(buttons[1]);
			stepUnload.attr('id', unloadName);
			initLoadAndUnloadEvents(loadName, loadSteps, true);
			initLoadAndUnloadEvents(unloadName, unloadSteps, false);
			// Update text elemnts
			$(this).find('.loadSteps').text(loadSteps);
			$(this).find('#inputNumber').attr('value', defaultMl);
			// Update input ID
			$(this).find('#inputNumber').attr('id', inputId);
		});
	};

	tabInit("tab1", "step1000Button", 1000, "step-1000Button", -1000, 1.0,
			"input1k");
	tabInit("tab2", "step2000Button", 2000, "step-2000Button", -2000, 2.0,
			"input2k");
	tabInit("tab3", "step4000Button", 4000, "step-4000Button", -4000, 4.0,
			"input4k");

};
