# Wal.md

**Since Camel 3.20**

The WAL component provides a resume strategy that uses a write-ahead log
to

A resume strategy that uses a write-ahead strategy to keep a transaction
log of the in-processing and processed records. This strategy works by
wrapping another strategy. This increases the reliability of the resume
API by ensuring that records are saved locally before being sent to the
remote data storage. Thus guaranteeing that records can be recovered in
case that system crashes.

# Usage

Because this strategy wraps another one, then the other one should be
created first and then passed as an argument to this strategy when
creating it.

    SomeOtherResumeStrategy resumeStrategy = new SomeOtherResumeStrategy();
    final String logFile = System.getProperty("wal.log.file");
    
    WriteAheadResumeStrategy writeAheadResumeStrategy = new WriteAheadResumeStrategy(new File(logFile), resumeStrategy);

Subsequently, this strategy should be registered to the registry instead

    getCamelContext().getRegistry().bind(ResumeStrategy.DEFAULT_NAME, writeAheadResumeStrategy);
    ...
    
    from("file:{{input.dir}}?noop=true&recursive=true&preSort=true")
        .resumable(ResumeStrategy.DEFAULT_NAME)
        .process(this::process)
        .to("file:{{output.dir}}");
