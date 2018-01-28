# $FreeBSD$

PORTNAME=	sqlite
PORTVERSION=	3.22.0
CATEGORIES=	local databases
MASTER_SITES=	https://www.sqlite.org/2018/ http://www2.sqlite.org/2018/ http://www3.sqlite.org/2018/
DISTNAME=	${PORTNAME}-src-${PORTVERSION:C/\.([[:digit:]])[[:>:]]/0\1/g:S/.//g}00

MAINTAINER=	pavelivolkov@gmail.com
COMMENT=	SQL database engine in a C library

LICENSE=	PD

USES=		autoreconf libtool ncurses pathfix zip
GNU_CONFIGURE=	yes
USE_LDCONFIG=	yes

CONFLICTS=	sqlite3-[0-9]*

# A directories and files has requires write permission on a target: test.
TEST_PERMISSION_CHANGED=	. tsrc .target_source sqlite3.c shell.c sqlite3ext.h sqlite3session.h .libs/sqlite3.o

#  Length         |     |                   Length                |

OPTIONS_SUB=		yes
OPTIONS_DEFAULT=	# Clean default options

# ===> OPTIONS_DEFINE
#OPTIONS_DEFINE=	# portlint, for what?

# https://www.sqlite.org/compile.html#enable_api_armor
OPTIONS_DEFINE=		ARMOR
ARMOR_DESC=		Detect misuse of the API
ARMOR_CPPFLAGS=		-DSQLITE_ENABLE_API_ARMOR=1

# https://sqlite.org/compile.html#enable_dbpage_vtab
OPTIONS_DEFINE+=	DBPAGE
DBPAGE_DESC=		Enable DBPAGE Virtual Table
DBPAGE_CPPFLAGS=	-DSQLITE_ENABLE_DBPAGE_VTAB=1

# https://www.sqlite.org/dbstat.html
OPTIONS_DEFINE+=	DBSTAT
OPTIONS_DEFAULT+=	DBSTAT # (since 41.0) used by www/firefox et al.
DBSTAT_DESC=		Enable DBSTAT Virtual Table
DBSTAT_CPPFLAGS=	-DSQLITE_ENABLE_DBSTAT_VTAB=1

# https://www.sqlite.org/compile.html#direct_overflow_read
OPTIONS_DEFINE+=	DIRECT_READ
DIRECT_READ_DESC=	File is read directly from disk
DIRECT_READ_CPPFLAGS=	-DSQLITE_DIRECT_OVERFLOW_READ=1

# https://www.sqlite.org/loadext.html
OPTIONS_DEFINE+=	EXTENSION
OPTIONS_DEFAULT+=	EXTENSION # It's SQLite default
EXTENSION_DESC=		Allow loadable external extensions
EXTENSION_CONFIGURE_OFF=	--disable-load-extension

# https://www.sqlite.org/json1.html
OPTIONS_DEFINE+=	JSON1
JSON1_DESC=		Enable the JSON1 extension
JSON1_CONFIGURE_ON=	--enable-json1

# https://sqlite.org/compile.html#like_doesnt_match_blobs
OPTIONS_DEFINE+=	LIKENOTBLOB
OPTIONS_DEFAULT+=	LIKENOTBLOB # my choice
LIKENOTBLOB_DESC=	LIKE does not match blobs
LIKENOTBLOB_CPPFLAGS=	-DSQLITE_LIKE_DOESNT_MATCH_BLOBS=1

# https://sqlite.org/compile.html#enable_memory_management
OPTIONS_DEFINE+=	MEMMAN
MEMMAN_DESC=		Allows it to release unused memory
MEMMAN_CPPFLAGS=	-DSQLITE_ENABLE_MEMORY_MANAGEMENT=1

# https://www.sqlite.org/compile.html#enable_column_metadata
OPTIONS_DEFINE+=	METADATA
OPTIONS_DEFAULT+=	METADATA # my choice
METADATA_DESC=		Enable column metadata
METADATA_CPPFLAGS=	-DSQLITE_ENABLE_COLUMN_METADATA=1

# https://www.sqlite.org/compile.html#enable_null_trim
OPTIONS_DEFINE+=	NULL_TRIM
NULL_TRIM_DESC=		Omits NULL columns at the ends of rows
NULL_TRIM_CPPFLAGS=	-DSQLITE_ENABLE_NULL_TRIM=1

# https://www.sqlite.org/compile.html#secure_delete
OPTIONS_DEFINE+=	SECURE_DELETE
OPTIONS_DEFAULT+=	SECURE_DELETE # (since 41.0) used by www/firefox et al.
SECURE_DELETE_DESC=	Overwrite deleted information with zeros
SECURE_DELETE_CPPFLAGS=	-DSQLITE_SECURE_DELETE=1

# https://www.sqlite.org/lang_corefunc.html#soundex
OPTIONS_DEFINE+=	SOUNDEX
SOUNDEX_DESC=		Enables the soundex() SQL function
SOUNDEX_CPPFLAGS=	-DSQLITE_SOUNDEX=1

# https://www.sqlite.org/compile.html#enable_stmt_scanstatus
OPTIONS_DEFINE+=	STMT
STMT_DESC=		Prepared Statement Scan Status
STMT_CPPFLAGS=		-DSQLITE_ENABLE_STMT_SCANSTATUS=1

# https://www.sqlite.org/tclsqlite.html
OPTIONS_DEFINE+=	TCL_EXT
OPTIONS_DEFAULT+=	TCL_EXT # It's SQLite default
TCL_EXT_DESC=		Do build and install TCL extension
TCL_EXT_USES=		tcl:,tea
TCL_EXT_USES_OFF=	tcl:,build
TCL_EXT_CONFIGURE_OFF=	--disable-tcl
PLIST_SUB+=		TCL_VER=${TCL_VER}

# https://www.sqlite.org/compile.html#threadsafe
OPTIONS_DEFINE+=	THREADS
OPTIONS_DEFAULT+=	THREADS # It's SQLite default
THREADS_CONFIGURE_OFF=	--disable-threadsafe

# http://sqlite.org/compile.html#enable_unknown_sql_function
OPTIONS_DEFINE+=	UNKNOWN_SQL
UNKNOWN_SQL_DESC=	Suppress unknown function errors in EXPLAIN
UNKNOWN_SQL_CPPFLAGS=	-DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION=1

# https://www.sqlite.org/unlock_notify.html
OPTIONS_DEFINE+=	UNLOCK_NOTIFY
OPTIONS_DEFAULT+=	UNLOCK_NOTIFY # (since 41.0) used by www/firefox et al.
UNLOCK_NOTIFY_DESC=	Enable notification on unlocking
UNLOCK_NOTIFY_CPPFLAGS=	-DSQLITE_ENABLE_UNLOCK_NOTIFY=1

# https://sqlite.org/compile.html#enable_update_delete_limit
OPTIONS_DEFINE+=	UPD_DEL_LIMIT
UPD_DEL_LIMIT_DESC=	ORDER BY and LIMIT on UPDATE and DELETE
UPD_DEL_LIMIT_CPPFLAGS=	-DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1

# ===> OPTIONS_GROUP
OPTIONS_GROUP=

# ===> I'm collect this as group, amalgamation or external extensions, don't included into other groups.
OPTIONS_GROUP+=		EXTG
OPTIONS_DEFAULT+=
EXTG_DESC=		Amalgamation or external extensions

# https://sqlite.org/src/file/ext/misc/appendvfs.c
# http://sqlite.org/vfs.html#shim
OPTIONS_GROUP_EXTG+=	APPENDVFS
APPENDVFS_DESC=		Allows appended DB to the end of other file
APPENDVFS_IMPLIES=	EXTENSION

# https://www.sqlite.org/csv.html
OPTIONS_GROUP_EXTG+=	CSV
CSV_DESC=		Reading CSV file as virtual table
CSV_IMPLIES=		EXTENSION

# https://www.sqlite.org/cli.html#file_i_o_functions
OPTIONS_GROUP_EXTG+=	FILEIO
FILEIO_DESC=		Presents external file as a BLOB
FILEIO_IMPLIES=		EXTENSION

# https://www.sqlite.org/rbu.html
OPTIONS_GROUP_EXTG+=	RBU
RBU_DESC=		Enable the Resumable Bulk Update
RBU_CPPFLAGS=		-DSQLITE_ENABLE_RBU=1

# https://www.sqlite.org/lang_expr.html and search "regexp"
OPTIONS_GROUP_EXTG+=	REGEXP
REGEXP_DESC=		Added a regexp() function
REGEXP_IMPLIES=		EXTENSION

# https://www.sqlite.org/sessionintro.html
OPTIONS_GROUP_EXTG+=	SESSION
SESSION_DESC=		Enable the SESSION extension
SESSION_CONFIGURE_ON=	--enable-session

# https://www.sqlite.org/spellfix1.html
OPTIONS_GROUP_EXTG+=	SPELLFIX
SPELLFIX_DESC=		Used to suggest corrections
SPELLFIX_IMPLIES=	EXTENSION

# https://www.sqlite.org/stmt.html
OPTIONS_GROUP_EXTG+=	STMTVTAB
STMTVTAB_DESC=		Information about all prepared statements
STMTVTAB_CPPFLAGS=	-DSQLITE_ENABLE_STMTVTAB=1

# https://www.sqlite.org/unionvtab.html
OPTIONS_GROUP_EXTG+=	UNIONVTAB
UNIONVTAB_DESC=		UNION virtual table
UNIONVTAB_IMPLIES=	EXTENSION

# https://sqlite.org/zipfile.html
OPTIONS_GROUP_EXTG+=	ZIPFILE
ZIPFILE_DESC=		Read/write access to simple ZIP archives
ZIPFILE_IMPLIES=	EXTENSION

# ===> end of EXTG

# https://www.sqlite.org/fts3.html
# https://www.sqlite.org/fts5.html
# https://www.sqlite.org/compile.html#enable_fts3_parenthesis
# https://www.sqlite.org/compile.html#enable_fts3_tokenizer
# https://www.sqlite.org/fts3.html#f3tknzr
OPTIONS_GROUP+=		FTS
OPTIONS_GROUP_FTS=	FTS3 FTS3_PARENTHESIS FTS3_TOKEN FTS4 FTS5
OPTIONS_DEFAULT+=	FTS4 # used by many ports
OPTIONS_DEFAULT+=	FTS3_TOKEN # used by audio/clementine-player
OPTIONS_DEFAULT+=	FTS5 # used by sysutils/tracker
FTS_DESC=		Full-text search
FTS3_DESC=		Enable the FTS3 extension
FTS3_PARENTHESIS_DESC=	Modifies the query pattern parser in FTS3
FTS3_TOKEN_DESC=	Enable two-args version fts3_tokenizer
FTS4_DESC=		Enable the FTS4 extension
FTS5_DESC=		Enable the FTS5 extension
FTS3_CONFIGURE_ON=	--enable-fts3
FTS3_PARENTHESIS_IMPLIES=	FTS3
FTS3_PARENTHESIS_CPPFLAGS=	-DSQLITE_ENABLE_FTS3_PARENTHESIS=1
FTS3_TOKEN_IMPLIES=	FTS3
FTS3_TOKEN_CPPFLAGS=	-DSQLITE_ENABLE_FTS3_TOKENIZER=1
FTS4_CONFIGURE_ON=	--enable-fts4
FTS4_IMPLIES=		FTS3 # used by www/firefox and mail/thunderbird
FTS5_CONFIGURE_ON=	--enable-fts5

# https://www.sqlite.org/rtree.html
# https://www.sqlite.org/compile.html#rtree_int_only
OPTIONS_GROUP+=		RTREEG
OPTIONS_GROUP_RTREEG=	RTREE RTREE_INT
OPTIONS_DEFAULT+=	RTREE # used by graphics/mapnik, databases/spatialite
RTREEG_DESC=		Dynamic Index Structure for Spatial Search
RTREE_DESC=		Special extension for doing range queries
RTREE_INT_DESC=		Store 32-bit sig int (no float) coordinates
RTREE_CONFIGURE_ON=	--enable-rtree
RTREE_INT_IMPLIES=	RTREE
RTREE_INT_CPPFLAGS=	-DSQLITE_RTREE_INT_ONLY=1

# https://www.sqlite.org/fts3.html#tokenizer
OPTIONS_GROUP+=		UNICODE
OPTIONS_GROUP_UNICODE=	ICU UNICODE61
OPTIONS_DEFAULT+=	UNICODE61  # It's SQLite default
UNICODE_DESC=		Unicode support
UNICODE61_DESC=		Unicode Version 6.1 tokenizer
UNICODE61_CPPFLAGS=	""
UNICODE61_CPPFLAGS_OFF=	-DSQLITE_DISABLE_FTS3_UNICODE=1
ICU_BUILD_DEPENDS=	${LOCALBASE}/bin/icu-config:devel/icu
ICU_LIB_DEPENDS=	libicudata.so:devel/icu
ICU_CPPFLAGS=		`${LOCALBASE}/bin/icu-config --cppflags` -DSQLITE_ENABLE_ICU=1
ICU_LIBS=		`${LOCALBASE}/bin/icu-config --ldflags`

# https://www.sqlite.org/uri.html
# https://www.sqlite.org/compile.html#allow_uri_authority
OPTIONS_GROUP+=		URIG
OPTIONS_GROUP_URIG=	URI URI_AUTHORITY
OPTIONS_DEFAULT+=	URI # my choice
URIG_DESC=		Uniform Resource Identifiers
URI_DESC=		Allow to treat the filename as a URI
URI_AUTHORITY_DESC=	Convert URI into UNC and pass to OS
URI_CPPFLAGS=		-DSQLITE_USE_URI=1
URI_AUTHORITY_CPPFLAGS=	-DSQLITE_ALLOW_URI_AUTHORITY=1

OPTIONS_GROUP+=		UTIL
OPTIONS_GROUP_UTIL=	ANALYZER DBHASH SQLDIFF
UTIL_DESC=		Additional utilities
# https://www.sqlite.org/sqlanalyze.html
# TCL already used in the build process.
ANALYZER_DESC=		Displays how efficiently space is used
ANALYZER_VARS=		TEST_PERMISSION_CHANGED+= sqlite3_analyzer.c
# https://www.sqlite.org/dbhash.html
DBHASH_DESC=		Hash on the content of the database
# https://www.sqlite.org/sqldiff.html
SQLDIFF_DESC=		Differences in content between databases

# ===> OPTIONS_SINGLE
OPTIONS_SINGLE=

# https://www.sqlite.org/tempfiles.html#tempstore
OPTIONS_SINGLE+=	RAMT
OPTIONS_SINGLE_RAMT=	TS0 TS1 TS2 TS3
OPTIONS_DEFAULT+=	TS1 # It's SQLite default
RAMT_DESC=		Use in-ram database for temporary tables
TS0_DESC=		Never
TS1_DESC=		No, may be changed with pragma
TS2_DESC=		Yes, may be changed with pragma
TS3_DESC=		Always
TS0_CONFIGURE_ON=	--enable-tempstore=never
TS1_CONFIGURE_ON=	--enable-tempstore=no
TS2_CONFIGURE_ON=	--enable-tempstore=yes
TS3_CONFIGURE_ON=	--enable-tempstore=always

# change read line support
OPTIONS_SINGLE+=	RL
OPTIONS_SINGLE_RL=	OFF_RL LIBEDIT READLINE
OPTIONS_DEFAULT+=	READLINE  # It's SQLite default
RL_DESC=		Library is used to edit the command line
OFF_RL_DESC=		Command line without editing
OFF_RL_CONFIGURE_ON=	--disable-readline --disable-editline # disable editline/readline support
LIBEDIT_CONFIGURE_ON=	--enable-editline # enable BSD editline support
LIBEDIT_USES=		libedit
READLINE_USES=		readline # enable GNU readline support
READLINE_CONFIGURE_ON=	--disable-editline

# ===> OPTIONS_RADIO
OPTIONS_RADIO=

# https://www.sqlite.org/compile.html#enable_memsys3
# https://www.sqlite.org/compile.html#enable_memsys5
OPTIONS_RADIO+=		MEMSYS
OPTIONS_RADIO_MEMSYS=	MEMSYS3 MEMSYS5
MEMSYS_DESC=		Alternative memory allocator
MEMSYS3_DESC=		Enable MEMSYS3
MEMSYS5_DESC=		Enable MEMSYS5
MEMSYS3_CONFIGURE_ON=	--enable-memsys3
MEMSYS5_CONFIGURE_ON=	--enable-memsys5

# https://www.sqlite.org/queryplanner-ng.html#qpstab
OPTIONS_RADIO+=		STAT
OPTIONS_RADIO_STAT=	STAT3 STAT4
STAT_DESC=		Which query planner to use Stability or ...
STAT3_DESC=		Collect histogram data from leftmost column
STAT4_DESC=		Collect histogram data from all columns
STAT3_CPPFLAGS=		-DSQLITE_ENABLE_STAT3=1
STAT4_CPPFLAGS=		-DSQLITE_ENABLE_STAT4=1

# ===> other definition

# https://www.sqlite.org/compile.html#default_file_permissions
.if defined(DEFAULT_FILE_PERMISSIONS) && !empty(DEFAULT_FILE_PERMISSIONS)
CPPFLAGS+=		-DSQLITE_DEFAULT_FILE_PERMISSIONS=${DEFAULT_FILE_PERMISSIONS}
.endif

# enable debugging & verbose explain
.if defined(WITH_DEBUG) && !defined(WITHOUT_DEBUG)
CONFIGURE_ARGS+=	--enable-debug
.endif

.include <bsd.port.options.mk>

post-configure:
	@${ECHO_MSG} "===> CONFIGURE_ARGS=${CONFIGURE_ARGS}"
	@${ECHO_MSG} "===> CPPFLAGS=${CPPFLAGS}"
	@${ECHO_MSG} "===> CFLAGS=${CFLAGS}"
	@${ECHO_MSG} "===> LDFLAGS=${LDFLAGS}"
	@${ECHO_MSG} "===> LIBS=${LIBS}"

post-build-ANALYZER-on:
	cd ${WRKSRC} && ${MAKE} sqlite3_analyzer

post-build-APPENDVFS-on:
	${CC} ${CFLAGS} -I${WRKSRC} -fPIC -DPIC -shared ${WRKSRC}/ext/misc/appendvfs.c -o ${WRKSRC}/appendvfs.so

post-build-CSV-on:
	${CC} ${CFLAGS} -I${WRKSRC} -fPIC -DPIC -shared ${WRKSRC}/ext/misc/csv.c -o ${WRKSRC}/csv.so

post-build-DBHASH-on:
	cd ${WRKSRC} && ${MAKE} dbhash

post-build-FILEIO-on:
	${CC} ${CFLAGS} -I${WRKSRC} -fPIC -DPIC -shared ${WRKSRC}/ext/misc/fileio.c -o ${WRKSRC}/fileio.so

post-build-REGEXP-on:
	${CC} ${CFLAGS} -I${WRKSRC} -fPIC -DPIC -shared ${WRKSRC}/ext/misc/regexp.c -o ${WRKSRC}/regexp.so

post-build-SPELLFIX-on:
	${CC} ${CFLAGS} -I${WRKSRC} -fPIC -DPIC -shared ${WRKSRC}/ext/misc/spellfix.c -o ${WRKSRC}/spellfix.so

post-build-SQLDIFF-on:
	cd ${WRKSRC} && ${MAKE} sqldiff

post-build-UNIONVTAB-on:
	${CC} ${CFLAGS} -I${WRKSRC} -fPIC -DPIC -shared ${WRKSRC}/ext/misc/unionvtab.c -o ${WRKSRC}/unionvtab.so

post-build-ZIPFILE-on:
	${CC} ${CFLAGS} -I${WRKSRC} -fPIC -DPIC -shared ${WRKSRC}/ext/misc/zipfile.c -o ${WRKSRC}/zipfile.so

post-install:
.if !defined(WITH_DEBUG) || defined(WITHOUT_DEBUG)
	@${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/sqlite3
	@${STRIP_CMD} ${STAGEDIR}${PREFIX}/lib/libsqlite3.so.0.8.6
.endif

post-install-TCL_EXT-on:
.if !defined(WITH_DEBUG) || defined(WITHOUT_DEBUG)
	@${STRIP_CMD} ${STAGEDIR}${PREFIX}/lib/tcl${TCL_VER}/sqlite3/libtclsqlite3.so
.endif

post-install-EXTENSION-off:
	${RM} ${STAGEDIR}${PREFIX}/include/sqlite3ext.h

post-install-ANALYZER-on:
	${INSTALL_PROGRAM} ${WRKSRC}/sqlite3_analyzer ${STAGEDIR}${PREFIX}/bin

post-install-APPENDVFS-on:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/appendvfs.so ${STAGEDIR}${DATADIR}

post-install-CSV-on:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/csv.so ${STAGEDIR}${DATADIR}

post-install-DBHASH-on:
	${INSTALL_PROGRAM} ${WRKSRC}/dbhash ${STAGEDIR}${PREFIX}/bin/sqlite3_dbhash

post-install-FILEIO-on:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/fileio.so ${STAGEDIR}${DATADIR}

post-install-REGEXP-on:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/regexp.so ${STAGEDIR}${DATADIR}

post-install-SPELLFIX-on:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/spellfix.so ${STAGEDIR}${DATADIR}

post-install-SQLDIFF-on:
	${INSTALL_PROGRAM} ${WRKSRC}/sqldiff ${STAGEDIR}${PREFIX}/bin/sqlite3_sqldiff

post-install-UNIONVTAB-on:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/unionvtab.so ${STAGEDIR}${DATADIR}

post-install-ZIPFILE-on:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/zipfile.so ${STAGEDIR}${DATADIR}

# for compares with checksum from of the site
sha1: fetch
.if defined(SHA1) && !empty(SHA1)
	@sha1 -c ${SHA1} ${DISTDIR}/${ALLFILES}
.else
	@sha1 ${DISTDIR}/${ALLFILES}
.endif

testfixture: build
	cd "${WRKSRC}" && ${MAKE} ${.TARGET}

test quicktest: testfixture
	[ -d "${WRKSRC}" ] && ( \
		cd "${WRKSRC}" && \
		${CHMOD} o+w ${TEST_PERMISSION_CHANGED} && \
		su -m nobody -c "limits -n 1000 ${MAKE} ${.TARGET}"; \
		${CHMOD} o-w ${TEST_PERMISSION_CHANGED} \
	)

.include <bsd.port.mk>
