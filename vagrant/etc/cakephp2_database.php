<?php
class DATABASE_CONFIG
{
    public $production = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'login' => '',
        'password' => '',
        'database' => '',
        'encoding' => 'utf8mb4',
    );

    public $staging = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'login' => '',
        'password' => '',
        'database' => '',
        'encoding' => 'utf8mb4',
    );

    public $development = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'login' => 'user',
        'password' => 'password',
        'database' => 'database_name',
        'encoding' => 'utf8mb4'
    );

    public $test = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'login' => 'user',
        'password' => 'password',
        'database' => 'test_database_name',
        'encoding' => 'utf8mb4'
    );

    public function __construct()
    {
        $env = env('CAKE_ENV');
        if (property_exists(__CLASS__, $env)) {
            $this->default = $this->{$env};
        } else {
            $this->default = $this->production;
        }
    }
}
