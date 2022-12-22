// library identifier: 'shared@master', retriever: modernSCM(
//     [$class: 'GitSCMSource',

pipeline {
    parameters {
        string(name: 'VERSION', defaultValue: '1.0.0', description: 'Test version')
        string(name: 'kiotviet', defaultValue: '', description: 'Kiotviet Environment')
        string(name: 'parallel', defaultValue: '8', description: 'Robot parallel process')
        string(name: 'account', defaultValue: 'admin', description: 'User account')
        string(name: 'headless_browser', defaultValue: 'T', description: 'F if browser is opened physically, T is vise versa')
        string(name: 'maychay', defaultValue: '', description: 'http://192.168.132.49:9999/wd/hub')
    		string(name: 'vietanh', defaultValue: '', description: 'http://192.168.132.51:9999/wd/hub')
    		string(name: 'trang', defaultValue: '', description: 'http://192.168.132.24:9999/wd/hub')
        string(name: 'maychay_F1', defaultValue: '', description: 'http://192.168.132.30:8888/wd/hub')
        string(name: 'maychay_F1_1', defaultValue: '', description: 'http://192.168.58.32:9999/wd/hub')
        string(name: 'maychay_F1_2', defaultValue: '', description: 'http://192.168.58.33:9999/wd/hub')
        string(name: 'thao', defaultValue: '', description: 'http://192.168.99.43:9999/wd/hub')
    }
	environment {
        kiotviet="${kiotviet}"
		remote1="http://192.168.132.49:9999/wd/hub"
		remote2="http://192.168.132.51:9999/wd/hub"
		remote3="http://192.168.132.24:9999/wd/hub"
    remote4="http://192.168.132.30:8888/wd/hub"
    remote5="http://192.168.58.32:9999/wd/hub"
    remote6="http://192.168.58.33:9999/wd/hub"
    remote7="http://192.168.99.43:9999/wd/hub"
        tagsRemote1="${maychay}"
        tagsRemote2="${vietanh}"
        tagsRemote3="${trang}"
        tagsRemote4="${maychay_F1}"
        tagsRemote5="${maychay_F1_1}"
        tagsRemote6="${maychay_F1_2}"
        tagsRemote7="${thao}"
        remote="${remote}"
        account="${account}"
        headless_browser="${headless_browser}"

    }
    agent any

    stages {
        stage ("Prepare") {
            steps {
                bat('pip install -r requirements.txt')
            }
        }

        stage ("Test") {
			parallel {
					stage (maychay) {
						steps {
							script {
								try {
									tagsArr=splitStr(tagsRemote1,",")
									tagsArr.each { itemTag ->
										try {
											powershell("""./run.ps1 -parallel ${parallel} -env ${kiotviet} -account ${account} -headless_browser ${headless_browser} -remote ${remote1} -tags ${itemTag}""")
										}catch (Exception e) {

										}
									}
								}
								catch (Exception e) {

								}

							}
						}
					}

					stage (vietanh) {
						steps {
							script {
								try {
									tagsArr=splitStr(tagsRemote2,",")
									tagsArr.each { itemTag ->
										try {
										   powershell("""./run.ps1 -parallel ${parallel} -env ${kiotviet} -account ${account} -headless_browser ${headless_browser} -remote ${remote2} -tags ${itemTag}""")
										}catch (Exception e) {

										}
									}
								}
								catch (Exception e) {

								}

							}
						}
					}

					stage (trang) {
						steps {
							script {
								try {
									tagsArr=splitStr(tagsRemote3,",")
									tagsArr.each { itemTag ->
										try {
											powershell("""./run.ps1 -parallel ${parallel} -env ${kiotviet} -account ${account} -headless_browser ${headless_browser} -remote ${remote3} -tags ${itemTag}""")
										}catch (Exception e) {

										}
									}
								}
								catch (Exception e) {

								}

							}
						}
					}


          stage (maychay_F1) {
						steps {
							script {
								try {
									tagsArr=splitStr(tagsRemote4,",")
									tagsArr.each { itemTag ->
										try {
										   powershell("""./run.ps1 -parallel ${parallel} -env ${kiotviet} -account ${account} -headless_browser ${headless_browser} -remote ${remote4} -tags ${itemTag}""")
										}catch (Exception e) {

										}
									}
								}
								catch (Exception e) {

								}

							}
						}
					}

          stage (maychay_F1_1) {
            steps {
              script {
                try {
                  tagsArr=splitStr(tagsRemote5,",")
                  tagsArr.each { itemTag ->
                    try {
                       powershell("""./run.ps1 -parallel ${parallel} -env ${kiotviet} -account ${account} -headless_browser ${headless_browser} -remote ${remote5} -tags ${itemTag}""")
                    }catch (Exception e) {

                    }
                  }
                }
                catch (Exception e) {

                }

              }
            }
          }

          stage (maychay_F1_2) {
						steps {
							script {
								try {
									tagsArr=splitStr(tagsRemote6,",")
									tagsArr.each { itemTag ->
										try {
										   powershell("""./run.ps1 -parallel ${parallel} -env ${kiotviet} -account ${account} -headless_browser ${headless_browser} -remote ${remote6} -tags ${itemTag}""")
										}catch (Exception e) {

										}
									}
								}
								catch (Exception e) {

								}

							}
						}
					}

          stage (thao) {
						steps {
							script {
								try {
									tagsArr=splitStr(tagsRemote7,",")
									tagsArr.each { itemTag ->
										try {
										   powershell("""./run.ps1 -parallel ${parallel} -env ${kiotviet} -account ${account} -headless_browser ${headless_browser} -remote ${remote7} -tags ${itemTag}""")
										}catch (Exception e) {

										}
									}
								}
								catch (Exception e) {

								}

							}
						}
					}

				}

		}
    }

    post {
        always {
            script {
                step([$class: "RobotPublisher",
                            disableArchiveOutput: false,
                            otherFiles: "",
                            outputFileName  : "**/output.xml",
                            reportFileName  : '**/report.html',
                            logFileName     : '**/log.html',
                            outputPath: "reports/",
                            passThreshold: 100,
                            unstableThreshold: 0])
                zip archive: true, dir: "reports", zipFile: "test-reports.zip"
                // emailNotifications VERSION
            }
        }
    }
}
def splitStr(str,param){
    return str.split(param)
}
