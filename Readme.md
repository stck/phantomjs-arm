<div align="center">
    <h1>PhantomJS for Alpine</h1>
	<p>
		<b>Unofficial images and prebuilts (musl aarch64/x86_64)</b>
	</p>
	<br>

</div>

PhantomJS doesn't provide packages for arm, so these packages are here to allow easy install of recent versions.

Packages were build from the PhantomJS
[source](https://github.com/ariya/phantomjs). 
For v2.1.1, you should be able to use the binaries on 3.17 and higher.

### Alpine
Image were built using alpine 3.17 in a single layer.
Available archs are:
- x86_64
- aarch64

### Do not use as a stage in multistaged builds
Building of PhantomJS in a limited environment (Docker) can last at least 2 hours.

### License
see PhantomJS [license](https://github.com/ariya/phantomjs/blob/master/LICENSE.BSD).
