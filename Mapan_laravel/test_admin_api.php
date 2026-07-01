<?php

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$request = Illuminate\Http\Request::create('/api/admin/detections', 'GET');
$controller = app()->make(App\Http\Controllers\Api\AdminApiController::class);
$response = $controller->detections($request);

echo json_encode($response->getData());
