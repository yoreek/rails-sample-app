var app = angular.module('myapplication', ['ngRoute', 'ngResource']);

// Routes
app.config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $routeProvider.when('/licenses',{
      templateUrl: '/templates/licenses/index.html',
      controller: 'LicenseListCtr'
    });
    $routeProvider.when('/licenses/new', {
      templateUrl: '/templates/licenses/new.html',
      controller: 'LicenseAddCtr'
    });
    $routeProvider.when('/licenses/:id/edit', {
      templateUrl: '/templates/licenses/edit.html',
      controller: "LicenseUpdateCtr"
    });
    $routeProvider.otherwise({
      redirectTo: '/licenses'
    });
  }
]);

// Factory
app.factory('Licenses', ['$resource',function($resource){
  return $resource('/licenses.json', {},{
    query: { method: 'GET', isArray: true },
    create: { method: 'POST' }
  })
}]);

app.factory('License', ['$resource', function($resource){
  return $resource('/licenses/:id.json', {}, {
    show: { method: 'GET' },
    update: { method: 'PUT', params: {id: '@id'} },
    delete: { method: 'DELETE', params: {id: '@id'} }
  });
}]);

app.factory('Plans', ['$resource',function($resource){
  return $resource('/plans.json', {},{
    query: { method: 'GET', isArray: true },
  })
}]);

// Controller
app.controller("LicenseListCtr", ['$scope', '$http', '$resource', 'Licenses', 'License', '$location', function($scope, $http, $resource, Licenses, License, $location) {

  $scope.licenses = Licenses.query();

  $scope.deleteLicense = function (licenseId) {
    if (confirm("Are you sure you want to delete this license?")){
      License.delete({ id: licenseId }, function(){
        $scope.licenses = Licenses.query();
        $location.path('/');
      });
    }
  };
}]);

app.controller("LicenseAddCtr",
  ['$scope', '$resource', 'Licenses', 'Plans', '$location',
  function($scope, $resource, Licenses, Plans, $location) {

  s = $scope;

  $scope.license = {
    licensor_id:        1,
    licensing_type:     'monthly',
    license_fees: [{
      amount:           1.0,
      start_date:       new Date('2016-11-01')
    }],
    license_mappings: [{
      mappable_type:    'Plan',
      plan: {
        selected: null,
        resource: {
          selected: null,
          options:  [],
        }
      }
    }]
  };

  $scope.licensing_type_options = {
    monthly:       'Monthly',
    revenue_share: 'Revenue share'
  };
  $scope.plan_options = [];

  $scope.plans = Plans.query({}, function (plans) {
    $scope.plan_options = plans;
    if (plans.length) {
      angular.forEach($scope.license.license_mappings, function(mapping, i) {
        mapping.plan.selected = plans[0];
        $scope.planChanged(plans[0], mapping);
      });
    }
  });

  $scope.planChanged = function(plan, mapping) {
    var res = mapping.plan.resource;
    res.options  = plan.plan_resources;
    if (res.options.length) {
      res.selected = res.options[0];
    }
  };

  $scope.save = function() {
    if ($scope.licenseForm.$valid){
      var formData = angular.merge({}, $scope.license);
      angular.forEach(formData.license_mappings, function(mapping, i) {
        var plan = mapping.plan;
        delete mapping.plan;
        mapping.mappable_id = mapping.mappable_type == 'Plan'
          ? plan.selected.id
          : plan.resource.selected.id;
      });
      Licenses.create({license: formData}, function() {
        $location.path('/');
      }, function(error){
        console.log(error);
      });
    }
  };

  $scope.addFee = function() {
    $scope.license.license_fees.push({ amount: 1, start_date: new Date() });
  }

  $scope.removeFee = function(index, license){
    license.license_fees.splice(index, 1);
  };

  $scope.addMapping = function() {
    var mapping = {
      mappable_type:    'Plan',
      plan: {
        selected: null,
        resource: {
          selected: null,
          options:  [],
        }
      }
    };
    if ($scope.plan_options.length) {
      mapping.plan.selected = $scope.plan_options[0];
      $scope.planChanged($scope.plan_options[0], mapping);
    }
    $scope.license.license_mappings.push(mapping);
  }

  $scope.removeMapping = function(index, license){
    license.license_mappings.splice(index, 1);
  };
}]);


app.controller("LicenseUpdateCtr", ['$scope', '$filter', '$resource', 'License', 'Plans', '$location', '$routeParams', function($scope, $filter, $resource, License, Plans, $location, $routeParams) {
  s = $scope;

  $scope.get_prop_by_value = function(k, v, arr) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i][k] == +v) {
            return arr[i];
        }
    }
    return null;
  };

  $scope.license = License.get({id: $routeParams.id}, function(data) {
    angular.forEach(data.license_fees, function(fee, i) {
      fee.amount = Number(fee.amount);
      fee.start_date = new Date(fee.start_date);
    });

    angular.forEach(data.license_mappings, function(mapping, i) {
      mapping.plan = {
        selected: null,
        resource: {
          selected: null,
          options:  [],
        }
      };
    });
  })

  $scope.licensing_type_options = {
    monthly:       'Monthly',
    revenue_share: 'Revenue share'
  };
  $scope.plan_options = [];

  $scope.plans = Plans.query({}, function (plans) {
    $scope.plan_options = plans;
    if (plans.length) {
      angular.forEach($scope.license.license_mappings, function(mapping, i) {
        if (mapping.mappable_type == 'Plan') {
          var plan = $scope.get_prop_by_value('id', mapping.mappable_id, plans);
          if (plan) {
            mapping.plan.selected = plan;
            $scope.planChanged(plan, mapping);
          }
        }
        else {
          for (var i in plans) {
            var plan = plans[i];
            var resource = $scope.get_prop_by_value('id', mapping.mappable_id, plan.plan_resources);
            if (resource) {
              mapping.plan.selected = plan;
              $scope.planChanged(plan, mapping);
              mapping.plan.resource.selected = resource;
              break;
            }
          }
        }
      });
    }
  });

  $scope.planChanged = function(plan, mapping) {
    var res = mapping.plan.resource;
    res.options  = plan.plan_resources;
    if (res.options.length) {
      res.selected = res.options[0];
    }
  };

  $scope.update = function(){
    if ($scope.licenseForm.$valid) {
      var formData = {
        id:               $scope.license.id,
        licensor_id:      $scope.license.licensor_id,
        name:             $scope.license.name,
        sku:              $scope.license.sku,
        status:           $scope.license.status,
        license_fees:     $scope.license.license_fees,
        license_mappings: []
      };
      angular.forEach($scope.license.license_mappings, function(mapping, i) {
        var plan = mapping.plan;
        formData.license_mappings.push({
          id:            mapping.id,
          mappable_type: mapping.mappable_type,
          mappable_id:   mapping.mappable_type == 'Plan'
            ? plan.selected.id
            : plan.resource.selected.id
        });
      });

      License.update({id: $scope.license.id},{license: formData},function(){
        $location.path('/');
      }, function(error) {
        console.log(error)
      });
    }
  };

  $scope.addFee = function() {
    $scope.license.license_fees.push({ amount: 1, start_date: new Date() });
  }

  $scope.removeFee = function(index, license){
    var fee = license.license_fees[index];
    if (fee.id){
      fee._destroy = true;
    }
    else {
      license.license_fees.splice(index, 1);
    }
  };

  $scope.addMapping = function() {
    var mapping = {
      mappable_type:    'Plan',
      plan: {
        selected: null,
        resource: {
          selected: null,
          options:  [],
        }
      }
    };
    if ($scope.plan_options.length) {
      mapping.plan.selected = $scope.plan_options[0];
      $scope.planChanged($scope.plan_options[0], mapping);
    }
    $scope.license.license_mappings.push(mapping);
  }

  $scope.removeMapping = function(index, license){
    license.license_mappings.splice(index, 1);
  };
}]);
