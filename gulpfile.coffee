gulp = require("gulp")
plugins = require("gulp-load-plugins")()


gulp.task "default", ["watch", "coffee"]


gulp.task "watch", ->
	gulp.watch(["./**/*.coffee", "!./node_modules/**", "!./gulpfile.coffee"], ["coffee"])
#	gulp.watch(["./gulpfile.coffee"], ["gulpfile"])


gulp.task "coffee", ->
	gulp.src(["./**/*.coffee", "!./node_modules/**", "!./gulpfile.coffee"])
		.pipe plugins.plumber(
			errorHandler: plugins.notify.onError(
				title: "task: coffee"
				message: "Error: <%= error.message %>"
			)
		)
		.pipe plugins.newer({dest:"./", ext:".min.js"})
		.pipe plugins.coffeelint()
		.pipe plugins.coffee({bare:false})
		.pipe gulp.dest("./")
		.pipe plugins.uglify()
		.pipe plugins.rename({extname: ".min.js"})
		.pipe gulp.dest("./")
