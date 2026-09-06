.class Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;
.super Ljava/lang/Object;
.source "TraktApi.java"

# interfaces
.implements Lretrofit2/Callback;


# instance fields
.field final outer:Lcom/tgomews/apihelper/api/trakt/TraktApi;

.field final kind:I

.field final type:Ljava/lang/String;

.field final extended:Ljava/lang/String;

.field final page:I

.field final accumulated:Ljava/util/ArrayList;

.field final finalCallback:Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;

.field final datasource:Lcom/tgomews/apihelper/api/Values$DATASOURCE;


# direct methods
.method constructor <init>(Lcom/tgomews/apihelper/api/trakt/TraktApi;ILjava/lang/String;Ljava/lang/String;ILjava/util/ArrayList;Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;Lcom/tgomews/apihelper/api/Values$DATASOURCE;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->outer:Lcom/tgomews/apihelper/api/trakt/TraktApi;

    iput p2, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->kind:I

    iput-object p3, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->type:Ljava/lang/String;

    iput-object p4, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->extended:Ljava/lang/String;

    iput p5, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->page:I

    iput-object p6, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->accumulated:Ljava/util/ArrayList;

    iput-object p7, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->finalCallback:Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;

    iput-object p8, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->datasource:Lcom/tgomews/apihelper/api/Values$DATASOURCE;

    return-void
.end method


# virtual methods
.method public onFailure(Lretrofit2/Call;Ljava/lang/Throwable;)V
    .locals 4

    new-instance v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;

    iget-object v1, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->outer:Lcom/tgomews/apihelper/api/trakt/TraktApi;

    iget-object v2, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->finalCallback:Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;

    iget-object v3, p0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->datasource:Lcom/tgomews/apihelper/api/Values$DATASOURCE;

    invoke-direct {v0, v1, v2, v3}, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;-><init>(Lcom/tgomews/apihelper/api/trakt/TraktApi;Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;Lcom/tgomews/apihelper/api/Values$DATASOURCE;)V

    invoke-virtual {v0, p1, p2}, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;->onFailure(Lretrofit2/Call;Ljava/lang/Throwable;)V

    return-void
.end method

.method public onResponse(Lretrofit2/Call;Lretrofit2/Response;)V
    .locals 25

    move-object/from16 v0, p0

    move-object/from16 v1, p2

    move-object/from16 v2, p1

    invoke-virtual {v1}, Lretrofit2/Response;->isSuccessful()Z

    move-result v3

    if-eqz v3, :cond_fail

    invoke-virtual {v1}, Lretrofit2/Response;->body()Ljava/lang/Object;

    move-result-object v4

    if-eqz v4, :cond_fail

    iget-object v5, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->accumulated:Ljava/util/ArrayList;

    check-cast v4, Ljava/util/List;

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    iget v6, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->page:I

    move v7, v6

    invoke-virtual {v1}, Lretrofit2/Response;->headers()Le/s;

    move-result-object v8

    if-eqz v8, :cond_skip_header

    const-string v9, "X-Pagination-Page-Count"

    invoke-virtual {v8, v9}, Le/s;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    if-eqz v9, :cond_skip_header

    :try_start_0
    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :cond_skip_header

    :cond_skip_header
    if-ge v6, v7, :cond_done

    add-int/lit8 v10, v6, 0x1

    iget-object v4, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->outer:Lcom/tgomews/apihelper/api/trakt/TraktApi;

    invoke-virtual {v4}, Lcom/tgomews/apihelper/api/trakt/TraktApi;->getTraktApiInterface()Lcom/tgomews/apihelper/api/trakt/services/TraktApiService;

    move-result-object v3

    iget v7, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->kind:I

    iget-object v8, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->type:Ljava/lang/String;

    iget-object v9, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->extended:Ljava/lang/String;

    const/16 v6, 0xfa

    if-nez v7, :cond_notk0

    invoke-interface {v3, v8, v9, v6, v10}, Lcom/tgomews/apihelper/api/trakt/services/TraktApiService;->getWatchedlist(Ljava/lang/String;Ljava/lang/String;II)Lretrofit2/Call;

    move-result-object v3

    goto :cond_dispatch_done

    :cond_notk0
    const/4 v11, 0x1

    if-ne v7, v11, :cond_notk1

    invoke-interface {v3, v8, v9, v6, v10}, Lcom/tgomews/apihelper/api/trakt/services/TraktApiService;->getCollection(Ljava/lang/String;Ljava/lang/String;II)Lretrofit2/Call;

    move-result-object v3

    goto :cond_dispatch_done

    :cond_notk1
    const/4 v11, 0x2

    if-ne v7, v11, :cond_notk2

    invoke-interface {v3, v8, v9, v6, v10}, Lcom/tgomews/apihelper/api/trakt/services/TraktApiService;->getRatings(Ljava/lang/String;Ljava/lang/String;II)Lretrofit2/Call;

    move-result-object v3

    goto :cond_dispatch_done

    :cond_notk2
    invoke-interface {v3, v8, v9, v6, v10}, Lcom/tgomews/apihelper/api/trakt/services/TraktApiService;->getWatchlist(Ljava/lang/String;Ljava/lang/String;II)Lretrofit2/Call;

    move-result-object v3

    :cond_dispatch_done
    iget-object v11, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->finalCallback:Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;

    iget-object v12, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->datasource:Lcom/tgomews/apihelper/api/Values$DATASOURCE;

    new-instance v16, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;

    move-object/from16 v17, v4

    move/from16 v18, v7

    move-object/from16 v19, v8

    move-object/from16 v20, v9

    move/from16 v21, v10

    move-object/from16 v22, v5

    move-object/from16 v23, v11

    move-object/from16 v24, v12

    invoke-direct/range {v16 .. v24}, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;-><init>(Lcom/tgomews/apihelper/api/trakt/TraktApi;ILjava/lang/String;Ljava/lang/String;ILjava/util/ArrayList;Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;Lcom/tgomews/apihelper/api/Values$DATASOURCE;)V

    move-object/from16 v4, v16

    invoke-interface {v3, v4}, Lretrofit2/Call;->enqueue(Lretrofit2/Callback;)V

    return-void

    :cond_done
    invoke-static {v5}, Lretrofit2/Response;->success(Ljava/lang/Object;)Lretrofit2/Response;

    move-result-object v3

    new-instance v4, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;

    iget-object v6, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->outer:Lcom/tgomews/apihelper/api/trakt/TraktApi;

    iget-object v7, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->finalCallback:Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;

    iget-object v8, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->datasource:Lcom/tgomews/apihelper/api/Values$DATASOURCE;

    invoke-direct {v4, v6, v7, v8}, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;-><init>(Lcom/tgomews/apihelper/api/trakt/TraktApi;Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;Lcom/tgomews/apihelper/api/Values$DATASOURCE;)V

    invoke-virtual {v4, v2, v3}, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;->onResponse(Lretrofit2/Call;Lretrofit2/Response;)V

    return-void

    :cond_fail
    new-instance v3, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;

    iget-object v4, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->outer:Lcom/tgomews/apihelper/api/trakt/TraktApi;

    iget-object v5, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->finalCallback:Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;

    iget-object v6, v0, Lcom/tgomews/apihelper/api/trakt/TraktApi$Pager;->datasource:Lcom/tgomews/apihelper/api/Values$DATASOURCE;

    invoke-direct {v3, v4, v5, v6}, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;-><init>(Lcom/tgomews/apihelper/api/trakt/TraktApi;Lcom/tgomews/apihelper/api/trakt/TraktApi$ApiResultCallback;Lcom/tgomews/apihelper/api/Values$DATASOURCE;)V

    invoke-virtual {v3, v2, v1}, Lcom/tgomews/apihelper/api/trakt/TraktApi$8;->onResponse(Lretrofit2/Call;Lretrofit2/Response;)V

    return-void
.end method
