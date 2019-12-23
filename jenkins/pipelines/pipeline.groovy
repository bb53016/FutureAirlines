

node ('deploy-client') {

  writeFile(file: "git-askpass-${BUILD_TAG}", text: "#!/bin/bash\ncase \"\$1\" in\nUsername*) echo \"\${STASH_USERNAME}\" ;;\nPassword*) echo \"\${STASH_PASSWORD}\" ;;\nesac")
  sh "chmod a+x git-askpass-${BUILD_TAG}"

  dir(env) {

    stage ('Checkout') {
      git_checkout()

   //Compute module will be run

    dir(terraformdir_compute) {

       stage ('Compute Stack Remote State') {
         terraformKey = "app_compute.tfstate"
         terraform_init(terraformBucket, terraformPrefix, terraformKey)
       }

       stage ('Compute Stack Plan') {
         global_tfvars = "../../environments/global.tfvars"
         env_tfvars = "../../environments/${terraformenv}.tfvars"
         terraform_plan(terraformenv, global_tfvars, env_tfvars)
       }

       if (terraformApplyPlan == 'true') {
         stage ('Compute Stack Apply') {
           terraform_apply()
         }
       }

     }

  }
}

def git_checkout() {
	checkout([$class: 'GitSCM', branches: [[name: gitBranch]], clearWorkspace: true, doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: true, recursiveSubmodules: true, reference: '', trackingSubmodules: false]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: gitCreds, url: gitUrl]]])
}

def terraform_init(terraformBucket,terraformPrefix,terraformkey) {
	withEnv(["GIT_ASKPASS=${WORKSPACE}/git-askpass-${BUILD_TAG}"]) {
		withCredentials([usernamePassword(credentialsId: gitCreds, passwordVariable: 'STASH_PASSWORD', usernameVariable: 'STASH_USERNAME')]) {
			sh "terraform init -no-color -force-copy -input=false -upgrade=true -backend=true -backend-config='bucket=${terraformBucket}' -backend-config='workspace_key_prefix=${terraformPrefix}' -backend-config='key=${terraformkey}'"
		    sh "terraform get -no-color -update=true"
		}
	}
}

def terraform_plan(workspace,global_tfvars,env_tfvars) {
	sh "terraform workspace new ${workspace}"
	sh "terraform workspace select ${workspace}"

    // This is only used for Windows AMIs, if Linux exclude the line below
    {
	    sh "terraform plan -no-color -out=tfplan -input=false -var-file=${global_tfvars} -var-file=${env_tfvars}"
	}
}

def terraform_apply() {
	sh "terraform apply -input=false -no-color tfplan"
}
