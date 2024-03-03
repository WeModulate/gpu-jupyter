LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at>, Mathematical Michael <consistentbayes@gmail.com>"

USER root

# Install useful packages and Graphviz
RUN apt-get update \
 && apt-get -y install --no-install-recommends htop apt-utils iputils-ping graphviz libgraphviz-dev openssh-client libatlas-base-dev python-dev-is-python3 gfortran pkg-config libfreetype6-dev hdf5-tools \
 && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && wget  http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz \
 && mv ta-lib-0.4.0-src.tar.gz / \
 && cd / \
 && tar -xzf ta-lib-0.4.0-src.tar.gz \
 && cd ta-lib \
 && ./configure \
 && make \
 && make install \
 && rm -f /ta-lib-0.4.0-src.tar.gz

USER $NB_UID

RUN set -ex \
 && buildDeps=' \
    graphviz==0.19.1 \
    pytest==7.2.2 \
' \
 && pip install --no-cache-dir $buildDeps \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# upgrade jupyter-server for compatibility
RUN pip install --no-cache-dir --upgrade \
    distributed==2023.3.0 \
    jupyter-server==2.4 \
    # fix permissions of conda
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

RUN pip install --no-cache-dir \
    # install extension manager
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator \
    # install git extension
    jupyterlab-git \
    # install plotly extension
    plotly \
    # install drawio and graphical extensions
    jupyterlab-drawio \
    rise \
    ipyleaflet \
    # install spell checker
    jupyterlab-spellchecker \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

RUN pip install --no-cache-dir \
    # install useful jupyter extensions
    python-dotenv \
    jupyter-ai \
    openai \
    jupyterlab_code_formatter \
    jupyterlab-templates \
    jupyterlab_widgets \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"


RUN pip install --no-cache-dir \
    # install quant packages
    alphalens-reloaded \
    arch \
    arcticdb \
    arviz \
    bambi \
    bcolz-zipline \
    # bcolz-zipline @ git+https://github.com/stefan-jansen/bcolz-zipline.git@main \
    black \
    bottleneck \
    dask \
    databento \
    databento-dbn \
    empyrical \
    evidently \
    exchange_calendars \
    finta \
    formulae \
    graphviz \
    hurst \
    ib_insync \
    ipympl \
    ipywidgets \
    isort \
    jedi-language-server \
    lightgbm \
    matplotlib \
    neptune \
    numba \
    numexpr \
    numpy \
    optuna \
    openai \
    pandas \
    py_vollib \
    py_vollib_vectorized \
    pyfolio-reloaded \
    pykalman \
    pymc \
    PyPortfolioOpt \
    pystore \
    pytensor \
    Quandl \
    quantstats \
    scikit-learn \
    scipy \
    sdepy \
    seaborn \
    shap \
    statsmodels \
    ta \
    trading-calendars \ 
    tzdata \
    xgboost \
    ydata-profiling \
    yellowbrick \
    yfinance \
    zipline-reloaded \
    # fix permissions of conda
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# Switch back to ${NB_UID} to avoid accidental container runs as root
USER $NB_UID
