class { 'symfony':
    withEnvironment     => true,
    withMySql           => true,
    withNodejs          => true,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false,
    withRabbitMQ        => true,
    withSelenium        => false,
    withRedis           => true,
    withDEVSettings     => false
}