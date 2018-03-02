var getResults = function() {

	var searchFieldValue = $("#search-field").val();
	$.ajax({
		url : "/bin/search",
		type : "POST",
		data : {
			"search-field" : searchFieldValue
		},
		success : function(result) {
			displayResults(result);
		}
	});

};

var displayResults = function(resultData) {
	var resultsJSON = JSON.parse(resultData)
	var results = [];
	var facets = [];

	if (!resultData || resultData == 'undefined') {
		$("#facets").html("No Results found.");
		return;
	}

	if (resultsJSON.facets) {
		$.each(resultsJSON.facets, function(key, val) {
			facets.push(key + "(" + val + ")");
		});
	}

	$.each(resultsJSON, function(key, val) {
		if (key != "facets")
			results.push("<a href='" + val + "'>" + key.substring(0, key.indexOf("*")) + "</a>");
	});

	$("#facets").html(facets.join("&emsp;"));
	$("#results").html(results.join("<br/>"));

};